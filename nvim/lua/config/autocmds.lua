local autocmds = require('utils.functions').autocmds

--- flash text on yank

autocmds('Highlights', {
    {
        events = { 'TextYankPost' },
        callback = function() vim.highlight.on_yank() end,
    },
})


--- Close / Delete selected buffers with <q>

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

local deleteable = {
    'netrw',
}

autocmds('UserDeleteWithQ', {{
    events = "FileType",
    pattern = deleteable,
    command = [[
      nnoremap <buffer><silent> q :bdelete<CR>
      set nobuflisted
    ]],
}})

-- vim: foldmethod=marker
