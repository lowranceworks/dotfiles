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
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      default_component_configs = {
        container = {
          enable_character_fade = true
        },
        indent = {
          indent_size = 2,
          padding = 1,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          with_expanders = nil,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
      },
      window = {
        position = "left",
        width = 55, -- Make neo-tree wider (default is 25)
        mapping_options = {
          noremap = true,
          nowait = true,
        },
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = true,
        },
        follow_current_file = {
          enabled = false,
        },
        group_empty_dirs = false,
        hijack_netrw_behavior = "open_default",
      },
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
