return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {},
  opts = function(_, opts)
    opts = vim.tbl_deep_extend("force", opts, {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignore = false,
        },
        window = {
          mappings = {
            ["<leader>a"] = "none", -- Disable the <leader>a mapping in filesystem view
            ["<leader>n"] = "add",
            -- Add file modification mappings
            ["r"] = "rename",
            ["d"] = "delete",
            ["c"] = "copy",
            ["m"] = "move",
            ["<leader>r"] = "refresh",
          },
        },
        commands = {
          -- Custom command to make buffer modifiable
          make_modifiable = function(state)
            vim.bo[state.bufnr].modifiable = true
            vim.bo[state.bufnr].readonly = false
          end,
        },
      },
      window = {
        position = "left",
        mappings = {
          ["<leader>a"] = "none", -- Disable the <leader>a mapping
          ["<leader>n"] = {
            command = "add",
            config = {
              show_path = "none",
            },
          },
          -- Global modification mappings
          ["r"] = "rename",
          ["d"] = "delete",
          ["c"] = "copy",
          ["m"] = "move",
          ["<leader>r"] = "refresh",
          ["<leader>m"] = "make_modifiable", -- Custom mapping to make modifiable
        },
      },
      -- Enable file operations
      enable_git_status = true,
      enable_diagnostics = true,
      -- Allow modifications
      hijack_netrw_behavior = "open_default",
    })

    -- Ensure the <leader>a mapping is removed from all sources
    local sources = { "filesystem", "buffers", "git_status" }
    for _, source in ipairs(sources) do
      if opts[source] and opts[source].window and opts[source].window.mappings then
        opts[source].window.mappings["<leader>a"] = "none"
      end
    end
    return opts
  end,
  config = function(_, opts)
    require("neo-tree").setup(opts)

    -- Make neo-tree buffer modifiable after setup
    vim.schedule(function()
      -- Remove the problematic mapping
      vim.cmd([[
        for m in ["n", "v", "o"]
          silent! nunmap <buffer> <leader>a
        endfor
      ]])

      -- Set up multiple autocmds to force modifiable state
      local augroup = vim.api.nvim_create_augroup("NeoTreeModifiable", { clear = true })

      -- Make modifiable on FileType
      vim.api.nvim_create_autocmd("FileType", {
        group = augroup,
        pattern = "neo-tree",
        callback = function(args)
          vim.schedule(function()
            vim.bo[args.buf].modifiable = true
            vim.bo[args.buf].readonly = false
            -- Optional: allow text editing in neo-tree buffer
            vim.keymap.set("n", "i", "i", { buffer = args.buf, desc = "Enter insert mode" })
            vim.keymap.set("n", "a", "a", { buffer = args.buf, desc = "Append after cursor" })
          end)
        end,
      })

      -- Force modifiable on buffer enter (in case neo-tree resets it)
      vim.api.nvim_create_autocmd("BufEnter", {
        group = augroup,
        pattern = "*",
        callback = function(args)
          if vim.bo[args.buf].filetype == "neo-tree" then
            vim.schedule(function()
              vim.bo[args.buf].modifiable = true
              vim.bo[args.buf].readonly = false
            end)
          end
        end,
      })

      -- Additional safety net - force modifiable on cursor hold
      vim.api.nvim_create_autocmd("CursorHold", {
        group = augroup,
        pattern = "*",
        callback = function(args)
          if vim.bo[args.buf].filetype == "neo-tree" and not vim.bo[args.buf].modifiable then
            vim.bo[args.buf].modifiable = true
            vim.bo[args.buf].readonly = false
          end
        end,
      })
    end)
  end,
}
