-- LazyVim defaults we don't want installed.
return {
  -- Active colorscheme is catppuccin (see colorscheme.lua); tokyonight is
  -- LazyVim's default theme and would otherwise still ship.
  { "folke/tokyonight.nvim", enabled = false },
  -- Snacks bufdelete + <S-h>/<S-l> replace the bufferline tab bar.
  { "akinsho/bufferline.nvim", enabled = false },
}
