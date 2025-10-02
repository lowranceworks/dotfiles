-- Plugin keymaps are defined in their respective plugin files for lazy loading
-- Snacks Explorer: <leader>e, <leader>fe
-- Snacks Picker (find/search): <leader><leader>, <leader>/, <leader>f*
-- Snacks Git: <leader>g* (lazygit, blame, commits, log)
-- Snacks Buffers: <leader>bd, <S-h>, <S-l>, [b, ]b, <leader>bo
-- Snacks Undo: <leader>u
-- Snacks Notifications: <leader>n, <leader>un
-- Harpoon: <leader>h*
-- LSP: gd, K, <leader>v*, [d, ]d
-- Comment: gcc, gc (native or plugin)
-- Which-key: <leader> (shows available keys)

-- Basic vim keymaps (non-plugin)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Keep visual selection when indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })
