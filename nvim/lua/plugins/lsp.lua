return {
  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {},
      },
    },

    -- LazyVim extra handles lspconfig, treesitter, mason and typescript setup
    { import = "lazyvim.plugins.extras.lang.typescript" },
  },
}
