return {
  "folke/which-key.nvim",
  lazy = false, -- Load at startup (needed for immediate access)
  event = "VeryLazy",
  dependencies = {
    "echasnovski/mini.icons",
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function()
    local wk = require("which-key")
    
    -- Use the new spec format
    wk.add({
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Harpoon" },
      { "<leader>v", group = "LSP/Code" },
    })
  end,
}
