return {
  "mbbill/undotree",
  lazy = true, -- Load when keymaps are triggered (saves startup time)
  config = function()
    -- Configuration settings for undotree go here
    -- If undotree has specific setup or configuration options,
    -- they should be included in this function block
  end,
  keys = {
    { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undotree" },
  },
}
