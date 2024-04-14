return {
  "mbbill/undotree",
  lazy = false,
  config = function()
    -- Configuration settings for undotree go here
    -- If undotree has specific setup or configuration options,
    -- they should be included in this function block
  end,
  keys = {
    { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undotree" },
  },
}
