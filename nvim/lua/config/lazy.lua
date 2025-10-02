-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim with LazyVim (proper spec format)
require("lazy").setup({
  spec = {
    -- Add LazyVim as a plugin with proper import
    {
      "LazyVim/LazyVim",
      version = false,
      import = "lazyvim.plugins",
      opts = {},
    },
    -- Import your custom plugins
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  checker = { enabled = true },
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

-- Load configurations with error handling (silent for missing files)
local function safe_require(module)
  local ok, _ = pcall(require, module)
  if not ok then
    -- Silently skip missing config files
    -- vim.notify("Config file not found: " .. module, vim.log.levels.WARN)
  end
end

safe_require("config.options")
safe_require("config.keymaps")
safe_require("config.autocmds")
