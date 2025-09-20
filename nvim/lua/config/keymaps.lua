-- Basic keymaps
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Telescope keymaps (default/common ones)
vim.keymap.set("n", "<leader><leader>", ":Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>/", ":Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent files" })
vim.keymap.set("n", "<leader>fc", ":Telescope commands<CR>", { desc = "Commands" })
vim.keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>", { desc = "Keymaps" })

-- LazyGit keymaps
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "LazyGit" })
vim.keymap.set("n", "<leader>gb", ":LazyGitFilter<CR>", { desc = "Git Blame" })
vim.keymap.set("n", "<leader>gc", ":LazyGitFilterCurrentFile<CR>", { desc = "Git Commits" })
vim.keymap.set("n", "<leader>gl", ":LazyGitFilter<CR>", { desc = "Git Log" })

-- Neo-tree keymaps
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
vim.keymap.set("n", "<leader>fe", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree (File Explorer)" })

-- Other plugin keymaps
vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { desc = "Toggle Undotree" })
vim.keymap.set("n", "<leader>o", ":Oil<CR>", { desc = "Open Oil" })

-- Harpoon keymaps
vim.keymap.set("n", "<leader>ha", ":lua require('harpoon.mark').add_file()<CR>", { desc = "Harpoon add file" })
vim.keymap.set("n", "<leader>hh", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", { desc = "Harpoon menu" })
vim.keymap.set("n", "<leader>h1", ":lua require('harpoon.ui').nav_file(1)<CR>", { desc = "Harpoon file 1" })
vim.keymap.set("n", "<leader>h2", ":lua require('harpoon.ui').nav_file(2)<CR>", { desc = "Harpoon file 2" })
vim.keymap.set("n", "<leader>h3", ":lua require('harpoon.ui').nav_file(3)<CR>", { desc = "Harpoon file 3" })
vim.keymap.set("n", "<leader>h4", ":lua require('harpoon.ui').nav_file(4)<CR>", { desc = "Harpoon file 4" })

-- LSP keymaps (add these when you set up LSP)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, { desc = "Workspace symbol" })
vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, { desc = "References" })
vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, { desc = "Signature help" })
