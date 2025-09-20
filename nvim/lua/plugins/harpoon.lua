return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<cr>", 
      desc = "Harpoon add file" },
    { "<leader>hh", 
      "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", 
      desc = "Harpoon menu" },
    { "<leader>h1", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", 
      desc = "Harpoon file 1" },
    { "<leader>h2", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", 
      desc = "Harpoon file 2" },
    { "<leader>h3", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", 
      desc = "Harpoon file 3" },
    { "<leader>h4", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", 
      desc = "Harpoon file 4" },
  },
  config = true,
}
