return {
  -- [[ Configure Treesitter ]]
  -- See `:help nvim-treesitter`
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false, -- Load at startup (needed for immediate access)
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    config = function()
      -- Add this line to ensure Neovim can find the parser directory
      vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/site")

      require("nvim-treesitter.configs").setup({
        parser_install_dir = vim.fn.stdpath("data") .. "/site",
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = {
          "go",
          "lua",
          "python",
          "typescript",
          "bash",
          "markdown",
          "markdown_inline",
          "sql",
          "terraform",
          "hcl",
          "html",
          "css",
          "javascript",
          "yaml",
          "json",
          "toml",
          "svelte",
          "dockerfile",
          "gitignore",
          "nix",
        },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<c-backspace>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ii"] = "@conditional.inner",
              ["ai"] = "@conditional.outer",
              ["il"] = "@loop.inner",
              ["al"] = "@loop.outer",
              ["at"] = "@comment.outer",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
      })
    end,
  },
}
