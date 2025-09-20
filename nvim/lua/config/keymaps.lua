-- Plugin keymaps are defined in their respective plugin files for lazy loading
-- Telescope: <leader><leader>, <leader>/, <leader>f*
-- LazyGit: <leader>g*
-- Neo-tree: <leader>e, <leader>fe
-- Harpoon: <leader>h*
-- Oil: <leader>o
-- Undotree: <leader>u
-- LSP: gd, K, <leader>v*, [d, ]d

-- Basic vim keymaps (non-plugin)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
