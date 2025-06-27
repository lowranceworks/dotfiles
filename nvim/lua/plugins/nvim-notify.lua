return {
  "rcarriga/nvim-notify",
  lazy = false, -- Load at startup (needed for immediate access)
  config = function()
    require("notify").setup({
      background_colour = "#000000",
      level = "info",
      timeout = 3000,
    })
    vim.notify = require("notify")
  end,
}
