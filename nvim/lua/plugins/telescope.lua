return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader><leader>", "<cmd>Telescope find_files<cr>", 
      desc = "Find files" },
    { "<leader>/", "<cmd>Telescope live_grep<cr>", 
      desc = "Live grep" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", 
      desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", 
      desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", 
      desc = "Find buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", 
      desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", 
      desc = "Recent files" },
    { "<leader>fc", "<cmd>Telescope commands<cr>", 
      desc = "Commands" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", 
      desc = "Keymaps" },
  },
  config = function()
    -- Your telescope configuration here
  end,
}
