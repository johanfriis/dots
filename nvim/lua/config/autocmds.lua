local f = require('utils.functions')

--- Close selected buffers with <q>

local closable = {
  'help',
  'query',
  'checkhealth',
  'startuptime',
}

f.autocmds('UserCloseWithQ', {{
    events = "FileType",
    pattern = closable,
    command = [[
      nnoremap <buffer><silent> q :close<CR>
      set nobuflisted
    ]],
}})

-- vim: foldmethod=marker ts=2 sts=2 sw=2 et
