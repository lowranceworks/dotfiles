return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Enable rename functionality for file operations
    rename = {
      enabled = true,
    },
    -- Configure file operations to prompt for rename on conflicts
    files = {
      enabled = true,
      -- Prompt for rename when file already exists
      confirm_rename = true,
      -- Show rename dialog on file conflicts
      rename_on_conflict = true,
    },
    -- Alternative: if using explorer/tree functionality
    explorer = {
      enabled = true,
      confirm = {
        -- Confirm before overwriting existing files
        overwrite = true,
        -- Prompt for rename instead of overwrite
        rename = true,
      },
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)
  end,
}
