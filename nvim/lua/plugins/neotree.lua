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
          },
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
        },
      },
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
    -- Forcefully remove the <leader>a mapping after setup
    vim.schedule(function()
      vim.cmd([[
        for m in ["n", "v", "o"]
          silent! nunmap <buffer> <leader>a
        endfor
      ]])
    end)
  end,
}
