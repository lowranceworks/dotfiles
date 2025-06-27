return {
  "stevearc/oil.nvim",
  lazy = true, -- Load when keymaps are triggered (saves startup time)
  enabled = false,
  config = function()
    require("oil").setup({})
    vim.oil = require("oil")
  end,
}
