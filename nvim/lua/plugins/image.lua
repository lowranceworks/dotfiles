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
    -- Hide an image when another window (e.g. the snacks grep/files
    -- picker float) overlaps it. Without this, a PNG open in a
    -- background window bleeds through floats under tmux.
    window_overlap_clear_enabled = true,
  },
}
