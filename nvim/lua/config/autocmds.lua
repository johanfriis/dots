local autocmds = require('utils.functions').autocmds

--- flash text on yank

autocmds('Highlights', {
  {
    events = { 'TextYankPost' },
    callback = function() vim.highlight.on_yank() end,
  },
})


--- Close selected buffers with <q>

local closable = {
  'help',
  'query',
  'checkhealth',
  'startuptime',
}

autocmds('UserCloseWithQ', {{
    events = "FileType",
    pattern = closable,
    command = [[
      nnoremap <buffer><silent> q :close<CR>
      set nobuflisted
    ]],
}})

-- vim: foldmethod=marker ts=2 sts=2 sw=2 et
