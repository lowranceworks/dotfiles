return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewFileHistory",
  },
  keys = {
    { "<leader>gd", "", desc = "+diffview" },
    { "<leader>gdd", "<cmd>DiffviewOpen<cr>", desc = "Open (working tree)" },
    { "<leader>gdc", "<cmd>DiffviewClose<cr>", desc = "Close" },
    { "<leader>gdh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (current file)" },
    { "<leader>gdH", "<cmd>DiffviewFileHistory<cr>", desc = "File history (repo)" },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default = { layout = "diff2_horizontal" },
      merge_tool = { layout = "diff3_mixed" },
    },
  },
}
