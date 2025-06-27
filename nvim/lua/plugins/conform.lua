return {
  "stevearc/conform.nvim",
  lazy = false, -- Load at startup (needed for immediate access)
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    formatters_by_ft = {
      javascript = {},
      typescript = {},
      javascriptreact = {},
      typescriptreact = {},
      svelte = { "prettier" },
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      graphql = { "prettier" },
      liquid = { "prettier" },
      lua = { "stylua" },
      python = { "isort", "black" },
    },
    formatters = {
      prettier = {
        prepend_args = { "--tab-width", "2" },
      },
    },
  },
}
