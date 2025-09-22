return {
  "kevinhwang91/nvim-hlslens",
  keys = {
    { "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]] },
    { "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]] },
    { "*", [[*<Cmd>lua require('hlslens').start()<CR>]] },
    { "#", [[#<Cmd>lua require('hlslens').start()<CR>]] },
    { "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]] },
    { "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]] },
    { "<leader>l", "<Cmd>noh<CR>", desc = "Clear search highlights" },
  },
  config = function()
    require('hlslens').setup({
      calm_down = true,
      nearest_only = false,
      nearest_float_when = 'auto', -- Changed from 'always' to 'auto'
      override_lens = function(render, posList, nearest, idx, relIdx)
        local sfw = vim.v.searchforward == 1
        local indicator, text, chunks
        local absRelIdx = math.abs(relIdx)
        if absRelIdx > 1 then
          indicator = ('%d%s'):format(absRelIdx, sfw ~= (relIdx > 1) and '▲' or '▼')
        elseif absRelIdx == 1 then
          indicator = sfw ~= (relIdx == 1) and '▲' or '▼'
        else
          indicator = ''
        end

        local lnum, col = unpack(posList[idx])
        if nearest then
          local cnt = #posList
          if indicator ~= '' then
            text = ('[%s %d/%d]'):format(indicator, idx, cnt)
          else
            text = ('[%d/%d]'):format(idx, cnt)
          end
          chunks = {{' '}, {text, 'HlSearchLensNear'}}
        else
          text = ('[%s %d]'):format(indicator, idx)
          chunks = {{' '}, {text, 'HlSearchLens'}}
        end
        render.setVirt(0, lnum - 1, col - 1, chunks, nearest)
      end
    })
  end,
}
