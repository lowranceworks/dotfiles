return {
  "3rd/image.nvim",
  ft = { "markdown", "norg" },
  event = "BufReadPre *.png,*.jpg,*.jpeg,*.gif,*.webp",
  opts = {
    backend = "kitty",
    integrations = {
      markdown = { enabled = true },
    },
    tmux_show_only_in_active_window = true,
  },
}
