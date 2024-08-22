--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.maplocalleader = " "
vim.g.mapleader = " "

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.termguicolors = true
