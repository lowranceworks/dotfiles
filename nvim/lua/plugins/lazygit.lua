return {
  "kdheepak/lazygit.nvim",
  lazy = false, -- Load at startup (needed for immediate access)
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    { "<leader>gb", "<cmd>LazyGitFilter<cr>", desc = "Git Blame" },
    { "<leader>gc", "<cmd>LazyGitFilterCurrentFile<cr>", 
      desc = "Git Commits" },
    { "<leader>gl", "<cmd>LazyGitFilter<cr>", desc = "Git Log" },
  },
}
