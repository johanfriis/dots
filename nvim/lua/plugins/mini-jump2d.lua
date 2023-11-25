_G.rose_pine_highlight_groups['MiniJump2dSpot'] = { fg = 'rose', bg = 'base' }

local opts = {
  labels = 'fjdksla;ghcnrueiwo'
}

return {
  {
    'echasnovski/mini.jump2d',
    event = 'BufReadPre',
    opts = opts,
  },
}
