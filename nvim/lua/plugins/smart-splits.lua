local f = require('utils.functions')
local smart = require('smart-splits')

f.map('n', '<C-h>', smart.move_cursor_left)
f.map('n', '<C-j>', smart.move_cursor_down)
f.map('n', '<C-k>', smart.move_cursor_up)
f.map('n', '<C-l>', smart.move_cursor_right)

f.map('n', '<A-h>', smart.resize_left)
f.map('n', '<A-j>', smart.resize_down)
f.map('n', '<A-k>', smart.resize_up)
f.map('n', '<A-l>', smart.resize_right)

f.map('n', '<leader><leader>h', smart.swap_buf_left)
f.map('n', '<leader><leader>j', smart.swap_buf_down)
f.map('n', '<leader><leader>k', smart.swap_buf_up)
f.map('n', '<leader><leader>l', smart.swap_buf_right)
