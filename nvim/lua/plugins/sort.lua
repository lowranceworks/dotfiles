return {
  "sQVe/sort.nvim", -- adds :Sort command
  lazy = true, -- Load when keymaps are triggered (saves startup time)
  config = function()
    require("sort").setup({
      -- Configuration options here
    })
  end,
}

