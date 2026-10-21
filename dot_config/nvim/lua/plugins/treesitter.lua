-- LazyVim core already configures nvim-treesitter for the main branch
-- (build, highlighting, folds, indent) and ships its own ensure_installed
-- list. This spec only extends that list (merged via opts_extend) with the
-- languages LazyVim doesn't cover. Master-branch keys like auto_install,
-- highlight.enable, and indent.enable are ignored by the main branch, so
-- they are intentionally not repeated here. Requires the tree-sitter CLI
-- (brew "tree-sitter-cli") to build parsers.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "hcl",
        "terraform",
      },
    },
  },
}
