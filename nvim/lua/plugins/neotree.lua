return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false, -- Load at startup (needed for immediate access)
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", 
      desc = "Toggle Neo-tree" },
    { "<leader>fe", "<cmd>Neotree toggle<cr>", 
      desc = "Toggle Neo-tree (File Explorer)" },
  },
  config = function()
    require("neo-tree").setup({
      -- Your existing config...
    })
    
    -- Auto-open neo-tree when starting nvim with a directory
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if vim.fn.argc() == 1 then
          local stat = vim.loop.fs_stat(vim.fn.argv(0))
          if stat and stat.type == "directory" then
            vim.cmd("Neotree show")
          end
        end
      end,
    })
  end,
}
