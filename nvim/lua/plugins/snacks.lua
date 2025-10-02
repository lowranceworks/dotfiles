return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    -- Explorer
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "Explorer",
    },
    {
      "<leader>fe",
      function()
        Snacks.explorer()
      end,
      desc = "Explorer (File Explorer)",
    },

    -- File/Search operations (replacing Telescope)
    {
      "<leader><leader>",
      function()
        Snacks.picker.files()
      end,
      desc = "Find files",
    },
    {
      "<leader>/",
      function()
        Snacks.picker.grep()
      end,
      desc = "Live grep",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find files",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Live grep",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Find buffers",
    },
    {
      "<leader>fh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help tags",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent files",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.commands()
      end,
      desc = "Commands",
    },
    {
      "<leader>fk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Keymaps",
    },

    -- Buffer operations (replacing BufferLine functionality)
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<S-h>",
      function()
        vim.cmd("bprevious")
      end,
      desc = "Prev buffer",
    },
    {
      "<S-l>",
      function()
        vim.cmd("bnext")
      end,
      desc = "Next buffer",
    },
    {
      "[b",
      function()
        vim.cmd("bprevious")
      end,
      desc = "Prev buffer",
    },
    {
      "]b",
      function()
        vim.cmd("bnext")
      end,
      desc = "Next buffer",
    },

    -- Git operations (replacing LazyGit plugin)
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "LazyGit",
    },
    {
      "<leader>gb",
      function()
        Snacks.picker.git_log_line()
      end,
      desc = "Git Blame",
    },
    {
      "<leader>gc",
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "Git Commits",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Git Log",
    },

    -- Undo history (replacing undotree)
    {
      "<leader>u",
      function()
        Snacks.picker.undo()
      end,
      desc = "Undo History",
    },

    -- Notifications
    {
      "<leader>n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },
  },
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = {
      enabled = true,
      char = "│", -- Visible indent character
      scope = {
        enabled = true,
        char = "│",
        underline = false,
        highlight = "CatppuccinGreen", -- Use your colorscheme's green
      },
    },
    input = { enabled = true },

    -- Buffer management (replacing BufferLine)
    bufdelete = { enabled = true },

    -- Git integration (replacing LazyGit plugin)
    lazygit = { enabled = true },

    -- Notifications (replacing nvim-notify)
    notifier = {
      enabled = true,
      timeout = 3000,
      style = "compact",
    },

    -- Picker (replacing Telescope)
    picker = {
      enabled = true,
      sources = {
        explorer = {
          layout = {
            layout = {
              width = 55,
              position = "left",
            },
          },
        },
      },
    },

    scratch = {
      enabled = false,
      win = {
        -- Hide scratch indicators
        wo = { statusline = "" },
      },
    },

    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  init = function()
    -- Set up vim.notify to use Snacks (replacing nvim-notify)
    vim.notify = function(msg, level, opts)
      return Snacks.notifier.notify(msg, level, opts)
    end

    -- Buffer navigation commands for BufferLine replacement
    vim.api.nvim_create_user_command("BufferCloseOthers", function()
      local current = vim.api.nvim_get_current_buf()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
          Snacks.bufdelete(buf)
        end
      end
    end, { desc = "Close all other buffers" })

    -- Add keymaps for buffer operations that BufferLine provided
    vim.keymap.set("n", "<leader>bo", "<cmd>BufferCloseOthers<cr>", { desc = "Close other buffers" })
  end,
}
