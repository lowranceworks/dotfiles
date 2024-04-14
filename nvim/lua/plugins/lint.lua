return {
  "mfussenegger/nvim-lint",
  config = function()
    -- nvim-lint configuration goes here
    require("lint").linters_by_ft = {
      markdown = {}, -- Disables linting for Markdown files
      -- Add configurations for other file types here
    }

    -- You can also set up autocommands to trigger linting, e.g.,
    vim.cmd([[
    augroup Linting
      autocmd!
      autocmd BufWritePost <buffer> lua require('lint').try_lint()
    augroup END
    ]])
  end,
}
