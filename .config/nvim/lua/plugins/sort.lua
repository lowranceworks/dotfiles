return {
  "sQVe/sort.nvim", -- adds :Sort command
  lazy = false, -- Adjust based on your preference
  config = function()
    require("sort").setup({
      -- Configuration options here
    })
  end,
}
