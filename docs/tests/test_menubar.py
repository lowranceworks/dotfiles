"""Check evaluated menu-bar configuration without writing macOS preferences.

Requires the repo's normal macOS tools: chezmoi, Nix, and cached flake inputs.
Run: python3 -B -m unittest discover -s docs/tests -v
"""
import json
import os
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path


class MenuBarActivationTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        repo = Path(__file__).resolve().parents[2]
        cls.workspace = tempfile.TemporaryDirectory(prefix='dotfiles-menubar-test-')
        cls.addClassCleanup(cls.workspace.cleanup)
        root = Path(cls.workspace.name)
        rendered = subprocess.run(
            ['chezmoi', 'execute-template'],
            input=(repo / 'dot_config/nix/flake.nix.tmpl').read_text(),
            text=True, capture_output=True, check=True, cwd=repo,
        )
        (root / 'flake.nix').write_text(rendered.stdout)
        shutil.copyfile(repo / 'dot_config/nix/flake.lock', root / 'flake.lock')
        expression = f'''let
          flake = builtins.getFlake {json.dumps('path:' + str(root))};
          config = (builtins.head (builtins.attrValues flake.darwinConfigurations)).config;
        in {{
          user = config.system.primaryUser;
          activation = config.system.activationScripts.postActivation.text;
          visibility = config.system.defaults.CustomUserPreferences."com.apple.controlcenter";
        }}'''
        evaluated = subprocess.run(
            ['nix', 'eval', '--offline', '--impure', '--json', '--expr', expression],
            text=True, capture_output=True, check=True,
        )
        cls.config = json.loads(evaluated.stdout)
        cls.uid = subprocess.check_output(['id', '-u', cls.config['user']], text=True).strip()
        script = cls.config['activation']
        cls.block = script[script.index('# Tahoe uses'):script.index('# Disable Cmd-Shift')]

    def run_menu_bar_block(self, macos_version):
        # Only the external preference-writing command is substituted: Bash
        # still parses and executes the actual Nix-generated command grouping.
        # A naked defaults call fails instead of changing this machine.
        harness = '''set -e
capture_sw_vers() { printf '%s\\n' "$TEST_MACOS_VERSION"; }
launchctl() {
  test "$1" = asuser
  test "$2" = "$TEST_UID"
  test "$3" = sudo
  test "$4" = "--user=$TEST_USER"
  test "$5" = --
  test "$6" = defaults
  shift 5
  printf '%s\\037' "$@"
  printf '\\n'
}
defaults() { echo 'unscoped defaults command' >&2; return 1; }
'''
        script = self.block.replace('/usr/bin/sw_vers', 'capture_sw_vers')
        result = subprocess.run(
            ['bash'], input=harness + script, text=True, capture_output=True,
            env={**os.environ, 'TEST_MACOS_VERSION': macos_version,
                 'TEST_USER': self.config['user'], 'TEST_UID': self.uid},
        )
        self.assertEqual(result.returncode, 0, result.stderr)
        return [line.rstrip('\x1f').split('\x1f') for line in result.stdout.splitlines()]

    def test_tahoe_writes_only_selected_keys_as_the_primary_user(self):
        commands = self.run_menu_bar_block('26.7.2')
        expected = [
            ['defaults', '-currentHost', 'write', 'com.apple.controlcenter', name, '-int', value]
            for name, value in [('Bluetooth', '2'), ('Display', '8'), ('NowPlaying', '8'),
                                ('ScreenMirroring', '8'), ('Sound', '8'), ('WiFi', '2')]
        ]
        expected.append([
            'defaults', 'write',
            f'/Users/{self.config["user"]}/Library/Group Containers/group.com.apple.controlcenter/Library/Preferences/group.com.apple.controlcenter',
            'showSpotlight', '-bool', 'false',
        ])
        self.assertEqual(commands, expected)

    def test_other_macos_majors_do_not_receive_private_tahoe_values(self):
        for version in ('14.4', '15.7', '27.0'):
            with self.subTest(version=version):
                self.assertEqual(self.run_menu_bar_block(version), [])

    def test_named_visibility_flags_do_not_transplant_layout_state(self):
        self.assertEqual(self.config['visibility'], {
            'NSStatusItem VisibleCC Battery': True,
            'NSStatusItem VisibleCC Bluetooth': True,
            'NSStatusItem VisibleCC WiFi': True,
            'NSStatusItem Visible Spotlight': False,
        })


if __name__ == '__main__':
    unittest.main()
