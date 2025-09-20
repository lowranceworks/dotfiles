return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
  },
  config = function()
    local wk = require("which-key")
    
    -- Register key groups for better organization
    wk.register({
      ["<leader>f"] = { name = "Find" },
      ["<leader>g"] = { name = "Git" },
      ["<leader>h"] = { name = "Harpoon" },
      ["<leader>v"] = { name = "LSP" },
      ["<leader>w"] = { name = "Workspace" },
    })
  end,
}
