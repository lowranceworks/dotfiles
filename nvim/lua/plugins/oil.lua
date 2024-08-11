return {
  "stevearc/oil.nvim",
  lazy = true,
  config = function()
    require("oil").setup({})
    vim.oil = require("oil")
  end,
}
