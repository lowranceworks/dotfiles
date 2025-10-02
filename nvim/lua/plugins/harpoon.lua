return {
  "ThePrimeagen/harpoon",
  lazy = false, -- Load at startup (needed for immediate access)
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>hm",
      "<cmd>lua require('harpoon.mark').add_file()<cr>",
      desc = "Mark file with harpoon",
    },
    {
      "<leader>hn",
      "<cmd>lua require('harpoon.ui').nav_next()<cr>",
      desc = "Go to next harpoon mark",
    },
    {
      "<leader>hp",
      "<cmd>lua require('harpoon.ui').nav_prev()<cr>",
      desc = "Go to previous harpoon mark",
    },
    {
      "<leader>ha",
      "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
      desc = "Show harpoon marks",
    },
  },
  config = function()
    require("harpoon").setup({
      global_settings = {
        save_on_toggle = false,
        save_on_change = true,
        enter_on_sendcmd = false,
        tmux_autoclose_windows = false,
        excluded_filetypes = { "harpoon" },
      },
    })
  end,
}
