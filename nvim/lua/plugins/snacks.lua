return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  --- https://github.com/folke/snacks.nvim
  opts = {
    explorer = {
      enabled = false, -- Make sure explorer is enabled
    },
    picker = {
      enabled = true,
      sources = {
        -- Configure the files source to show hidden files
        files = {
          hidden = true,
          -- Exclude specific directories using rg_opts
          rg_opts = "--glob=!**/.git/** --glob=!**/.terraform/**",
        },
        -- Configure the grep source to also show hidden files
        grep = {
          hidden = true,
          rg_opts = "--glob=!**/.git/** --glob=!**/.terraform/**",
        },
        -- Configure the explorer source to show hidden files
        explorer = {
          hidden = true,
        },
      },
    },
  },
}
