return {
  {
    "lemarsu/sops.nvim",
    opts = {},
    config = function(_, opts)
      require("sops").setup(opts)
      vim.cmd("cabbrev sops Sops")
    end,
  },
}
