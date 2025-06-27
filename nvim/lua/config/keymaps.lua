-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: You can find this in init.lua

-- navigation
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- Center view when scrolling half-page up
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Center view when scrolling half-page down
vim.keymap.set("n", "#", "#zz") -- Center view when searching backward for word under cursor
vim.keymap.set("n", "*", "*zz") -- Center view when searching forward for word under cursor
vim.keymap.set("n", "n", "nzz") -- Center view when moving to next search result
vim.keymap.set("n", "N", "Nzz") -- Center view when moving to previous search result

--[[
USEFUL KEYMAPS TO REMEMBER:

LazyGit:
- <leader>g  = Toggle LazyGit
- <leader>gb = Git Blame Line
- <leader>gc = Commits
- <leader>gg = LazyGit (Root Dir)
- <leader>gG = LazyGit (Current Dir)
- <leader>gl = Git Log
- <leader>gL = Git Log (Current Dir)
- <leader>gs = Git Status

Neo-tree:
- D = Delete without confirmation (works with multiple selections)
- d = Delete with y/n confirmation
- c = Copy to clipboard
- x = Cut to clipboard
- r = Rename
- a = Add new file/folder

File Navigation:
- <leader>fe                     = Toggle Neo-tree
- <leader>ff or <leader><leader> = Find files
- <leader>sg or <leader>/        = Live grep
]]
