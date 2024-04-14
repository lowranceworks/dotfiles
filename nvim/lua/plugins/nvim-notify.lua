return {
  "rcarriga/nvim-notify",
  lazy = false, -- This can be set to true if you want to load it on-demand
  config = function()
    require("notify").setup({
      background_colour = "#000000",
      level = "info",
      timeout = 3000,
    })
    vim.notify = require("notify")
  end,
}
