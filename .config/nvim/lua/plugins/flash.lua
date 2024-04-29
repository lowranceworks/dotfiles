-- Flash lets you navigate your code with search labels, enhanced character motions, and Treesitter integration.
-- While searching with words with "/" you may find yourself outside of the search box before pressing enter.
-- Press <C-s> while in search mode to temporarily disable this feature in case you want to use it another time.
-- https://github.com/LazyVim/LazyVim/discussions/1410
-- https://github.com/folke/flash.nvim
return {
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        search = {
          enabled = true,
        },
      },
    },
  },
}
