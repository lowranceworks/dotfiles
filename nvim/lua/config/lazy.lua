local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- Only import the LazyVim base configuration
    {
      "LazyVim/LazyVim",
      import = "lazyvim.config",
      opts = {
        defaults = {
          autocmds = true, -- lazyvim.config.autocmds
          keymaps = true, -- lazyvim.config.keymaps
          options = true, -- lazyvim.config.options
        },
      },
    },
    -- Import only your custom plugins
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
