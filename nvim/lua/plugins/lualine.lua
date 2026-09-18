return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "catppuccin/nvim" },
  event = "VeryLazy",
  opts = {
    options = {
      theme = "catppuccin-mocha",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
  },
}
