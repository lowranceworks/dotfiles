return {
  "akinsho/bufferline.nvim",
  lazy = false, -- Load at startup (needed for immediate access)
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", 
      desc = "Delete non-pinned buffers" },
    { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", 
      desc = "Delete other buffers" },
    { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", 
      desc = "Delete buffers to the right" },
    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", 
      desc = "Delete buffers to the left" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
  },
  opts = {
    options = {
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      diagnostics_indicator = function(_, _, diag)
        local icons = { Error = " ", Warn = " ", Info = " " }
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
      },
    },
  },
  config = function(_, opts)
    require("bufferline").setup(opts)
  end,
}
