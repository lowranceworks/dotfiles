"""Exercise skill deployment boundaries without changing live installations.

Requires chezmoi, git, and skills v0.2.1 on PATH. All CLI installs use temporary
homes and local Git fixtures; no remote repositories are contacted.
Run: python3 -B -m unittest discover -s docs/tests -v
"""
import json
import os
import shutil
import subprocess
import tempfile
import tomllib
import unittest
from pathlib import Path
from unittest.mock import patch


REPO = Path(__file__).resolve().parents[2]
SKILL_NAMES = {
    'ansible-dev', 'argocd-akuity', 'cleanup-branch', 'coordinator', 'fan-out',
    'github-app-token', 'go-ci', 'go-dev', 'merge', 'obsidian-daily-journal',
    'open-pr', 'python-dev', 'rebase', 'release-please', 'repo-hardening',
    'split-commits', 'terraform-dev', 'workmux', 'worktree',
}


def run(*args, cwd=REPO, env=None, input=None, check=True):
    return subprocess.run(
        args, cwd=cwd, env=env, input=input, text=True, capture_output=True,
        check=check,
    )


def render(path):
    return run('chezmoi', '--source', str(REPO), 'execute-template',
               input=path.read_text()).stdout


class SkillsDeploymentTests(unittest.TestCase):
    def manifest(self):
        content = run('chezmoi', '--source', str(REPO), 'cat',
                      str(Path.home() / '.config/skills/skills.toml')).stdout
        return tomllib.loads(content)

    def fixture(self, root, name='source'):
        _, env = self.isolated_env(root)
        source = root / name
        source.mkdir()
        run('git', 'init', '-q', '-b', 'main', cwd=source, env=env)
        run('git', 'config', 'user.name', 'Skills Test', cwd=source, env=env)
        run('git', 'config', 'user.email', 'skills-test@example.invalid', cwd=source, env=env)
        return source

    def commit(self, source):
        _, env = self.isolated_env(source.parent)
        run('git', 'add', '.', cwd=source, env=env)
        run('git', '-c', 'core.hooksPath=/dev/null', 'commit', '-qm',
            'test: commit skill fixture', cwd=source, env=env)

    def isolated_env(self, root):
        home = root / 'home'
        home.mkdir(exist_ok=True)
        templates = root / 'empty-git-templates'
        templates.mkdir(exist_ok=True)
        env = {key: value for key, value in os.environ.items()
               if not key.startswith('GIT_') and key not in ('CI', 'SKILLS_DIR', 'SKILLS_CONFIG')}
        env.update(HOME=str(home), GIT_CONFIG_NOSYSTEM='1',
                   GIT_CONFIG_GLOBAL=os.devnull, GIT_TEMPLATE_DIR=str(templates))
        return home, env

    def test_fixture_git_commands_ignore_ambient_repository_overrides(self):
        with tempfile.TemporaryDirectory(prefix='dotfiles-skills-env-') as tmp:
            root = Path(tmp)
            victim = root / 'unrelated-repository'
            victim.mkdir()
            _, clean_env = self.isolated_env(root)
            run('git', 'init', '-q', cwd=victim, env=clean_env)
            run('git', 'config', 'user.name', 'Original Owner', cwd=victim, env=clean_env)
            with patch.dict(os.environ, {'GIT_DIR': str(victim / '.git'),
                                         'GIT_WORK_TREE': str(victim)}):
                self.fixture(root)
            owner = run('git', 'config', 'user.name', cwd=victim, env=clean_env).stdout.strip()
            self.assertEqual(owner, 'Original Owner', 'fixture Git must not target an ambient repository')

    def test_chezmoi_does_not_deploy_sources_or_own_installed_skills(self):
        managed = run('chezmoi', '--source', str(REPO), 'managed').stdout.splitlines()
        owned = [p for p in managed if p == 'skills' or p.startswith('skills/')
                 or p == '.agents/skills' or p.startswith('.agents/skills/')]
        self.assertEqual(owned, [], 'skills CLI must be the sole installer')

    def test_manifest_has_one_pi_discovery_target_and_local_collection(self):
        manifest = self.manifest()
        self.assertEqual(manifest['default_targets'], ['agents'])
        sources = {entry['source']: entry for entry in manifest['skill']}
        self.assertIn(str(REPO), sources, 'render the local repo root, not a skill subpath')
        self.assertNotIn('path', sources[str(REPO)])
        self.assertEqual(sources[str(REPO)]['scope'], 'global')
        self.assertIn('obra/superpowers', sources)
        self.assertEqual(sources['antonbabenko/terraform-skill']['skills'], ['terraform-skill'])

    def test_collection_sync_uses_committed_files_and_preserves_supporting_assets(self):
        collection = REPO / 'skills'
        self.assertTrue(collection.is_dir(), 'custom collection must be discoverable at skills/')
        with tempfile.TemporaryDirectory(prefix='dotfiles-skills-test-') as tmp:
            root = Path(tmp)
            source = self.fixture(root)
            shutil.copytree(collection, source / 'skills')
            self.commit(source)
            committed = (source / 'skills/open-pr/SKILL.md').read_bytes()
            (source / 'skills/open-pr/SKILL.md').write_text('uncommitted edit must not install\n')
            (source / 'skills/untracked').mkdir()
            (source / 'skills/untracked/SKILL.md').write_text('untracked skill\n')
            home, env = self.isolated_env(root)
            manifest = root / 'skills.toml'
            manifest.write_text(
                'default_targets = ["agents"]\n[[skill]]\n'
                f'source = {json.dumps(str(source))}\nscope = "global"\n'
            )
            run('skills', 'sync', '--config', str(manifest), cwd=root, env=env)
            installed = home / '.agents/skills'
            self.assertEqual({p.name for p in installed.iterdir() if p.is_dir()}, SKILL_NAMES)
            self.assertEqual((installed / 'open-pr/SKILL.md').read_bytes(), committed)
            self.assertEqual(
                (installed / 'repo-hardening/RULESET-PAYLOAD.json').read_bytes(),
                (collection / 'repo-hardening/RULESET-PAYLOAD.json').read_bytes(),
            )
            self.assertFalse((home / '.pi/agent/skills').exists())
            lock = tomllib.loads((installed / '.skills.lock.toml').read_text())
            self.assertEqual({entry['name'] for entry in lock['skill']}, SKILL_NAMES)

    def test_source_failure_does_not_prune_existing_installs(self):
        with tempfile.TemporaryDirectory(prefix='dotfiles-skills-failure-') as tmp:
            root = Path(tmp)
            source = self.fixture(root)
            (source / 'SKILL.md').write_text('---\nname: retained-skill\ndescription: Test fixture\n---\n')
            self.commit(source)
            home, env = self.isolated_env(root)
            manifest = home / '.config/skills/skills.toml'
            manifest.parent.mkdir(parents=True)
            manifest.write_text(
                'default_targets = ["agents"]\n[[skill]]\n'
                f'source = {json.dumps(str(source))}\nscope = "global"\n'
            )
            run('skills', 'sync', '--config', str(manifest), cwd=root, env=env)
            original = (home / '.agents/skills/retained-skill/SKILL.md').read_bytes()
            manifest.write_text(
                'default_targets = ["agents"]\n[[skill]]\n'
                f'source = {json.dumps(str(root / "unavailable-repo"))}\nscope = "global"\n'
            )
            script = render(REPO / '.chezmoiscripts/run_onchange_after_15-skills-sync.sh.tmpl')
            result = run('bash', cwd=root, env=env, input=script, check=False)
            self.assertNotEqual(result.returncode, 0, 'a source failure must be reported')
            retained = home / '.agents/skills/retained-skill/SKILL.md'
            self.assertTrue(retained.exists(), 'failed sync must not prune installed skills')
            self.assertEqual(retained.read_bytes(), original)


if __name__ == '__main__':
    unittest.main()
