-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Basic autocmds
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Make all buffers modifiable by default (resolves E21: Cannot make changes, 'modifiable' is off)
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("SetModifiable", { clear = true }),
  pattern = "*",
  callback = function()
    vim.bo.modifiable = true
  end,
})
