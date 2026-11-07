return {
  "sphamba/smear-cursor.nvim",
  event = "VeryLazy",
  opts = {
    -- Animate the cursor when jumping between buffers/windows
    smear_between_buffers = true,
    -- Animate short hops (scrolling, adjacent line moves) too
    smear_between_neighbor_lines = true,
    -- Animation feel: higher stiffness = snappier, lower = longer smear
    stiffness = 0.8,
    trailing_stiffness = 0.5,
    distance_stop_animating = 0.5,
    -- Keep the real cursor visible; hide the native cursor during animation
    hide_target_hack = true,
    cursor_color = "none", -- follow the colorscheme's cursor color
  },
}
