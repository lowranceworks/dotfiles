return {
  "nvim-telescope/telescope.nvim",
  lazy = true, -- Load when keymaps are triggered (saves startup time)
  tag = "0.1.5",
  dependencies = { "nvim-lua/plenary.nvim" },
  lazy = false,
  config = true,
  keys = {
    { "<leader>pf", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Find files" },
    { "<C-p>", "<cmd>lua require('telescope.builtin').git_files()<cr>", desc = "Find Git files" },
    {
      "<leader>ps",
      "<cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input('Grep > ') })<cr>",
      desc = "Grep string",
    },
    { "<leader>vh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", desc = "Find help tags" },
  },
}
