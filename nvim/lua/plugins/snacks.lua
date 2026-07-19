-- Hide image.nvim's images *before* a floating picker builds its layout.
-- Snacks' on_show hook fires after the float is created, leaving a one-frame
-- window where the image re-renders at a shifted position (the flicker). By
-- clearing here first, the picker opens with no image on screen; on_close
-- restores it.
local function pick(fn)
  return function()
    if package.loaded["image"] then
      require("image").disable()
    end
    fn()
  end
end

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
      pick(function()
        Snacks.picker.files()
      end),
      desc = "Find files",
    },
    {
      "<leader>/",
      pick(function()
        Snacks.picker.grep()
      end),
      desc = "Live grep",
    },
    {
      "<leader>ff",
      pick(function()
        Snacks.picker.files()
      end),
      desc = "Find files",
    },
    {
      "<leader>fg",
      pick(function()
        Snacks.picker.grep()
      end),
      desc = "Live grep",
    },
    {
      "<leader>fb",
      pick(function()
        Snacks.picker.buffers()
      end),
      desc = "Find buffers",
    },
    {
      "<leader>fh",
      pick(function()
        Snacks.picker.help()
      end),
      desc = "Help tags",
    },
    {
      "<leader>fr",
      pick(function()
        Snacks.picker.recent()
      end),
      desc = "Recent files",
    },
    {
      "<leader>fc",
      pick(function()
        Snacks.picker.commands()
      end),
      desc = "Commands",
    },
    {
      "<leader>fk",
      pick(function()
        Snacks.picker.keymaps()
      end),
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
      pick(function()
        Snacks.picker.git_log_line()
      end),
      desc = "Git Blame",
    },
    {
      "<leader>gc",
      pick(function()
        Snacks.picker.git_log_file()
      end),
      desc = "Git Commits",
    },
    {
      "<leader>gl",
      pick(function()
        Snacks.picker.git_log()
      end),
      desc = "Git Log",
    },

    -- Undo history (replacing undotree)
    {
      "<leader>u",
      pick(function()
        Snacks.picker.undo()
      end),
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
        highlight = "CatppuccinMauve", -- Change from Green to Mauve for accent
      },
    },
    input = { enabled = true },

    -- Disable snacks' image viewer. Its picker preview renders into a
    -- floating window, and tmux can't position terminal-graphics images
    -- inside floats (they splatter at the terminal origin). With this
    -- off, the picker falls back to a plain "binary file" text preview.
    -- Actual image/markdown files still render via image.nvim in normal
    -- (non-floating) windows, which works fine under tmux.
    image = { enabled = false },

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

    picker = {
      enabled = true,
      hidden = true, -- Show hidden files by default
      follow = false, -- Don't follow symlinks
      -- Under tmux, terminal-graphics images render on top of floating
      -- windows, so a PNG open in a background window bleeds through the
      -- grep/files picker float. Overlap-masking doesn't survive tmux's
      -- passthrough, so instead fully hide image.nvim's images while a
      -- floating picker is open and restore them on close. Skip the
      -- explorer: it's a persistent sidebar, not a float over the image.
      on_show = function(picker)
        if picker.opts.source ~= "explorer" and package.loaded["image"] then
          require("image").disable()
        end
      end,
      on_close = function(picker)
        if picker.opts.source ~= "explorer" and package.loaded["image"] then
          require("image").enable()
        end
      end,
      sources = {
        grep = {
          hidden = true,
          follow = false,
        },
        files = {
          hidden = true,
        },
        explorer = {
          hidden = true,
          layout = {
            layout = {
              width = 40,
              position = "left",
            },
          },
          win = {
            list = {
              keys = {
                ["<C-h>"] = {
                  function() vim.cmd("TmuxNavigateLeft") end,
                  mode = { "n", "i" },
                  desc = "Navigate left (tmux)",
                },
                ["<C-j>"] = {
                  function() vim.cmd("TmuxNavigateDown") end,
                  mode = { "n", "i" },
                  desc = "Navigate down (tmux)",
                },
                ["<C-k>"] = {
                  function() vim.cmd("TmuxNavigateUp") end,
                  mode = { "n", "i" },
                  desc = "Navigate up (tmux)",
                },
                ["<C-l>"] = {
                  function() vim.cmd("TmuxNavigateRight") end,
                  mode = { "n", "i" },
                  desc = "Navigate right (tmux)",
                },
              },
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
