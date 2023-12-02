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

f.leader('n', 'bh', smart.swap_buf_left,  "Swap Left")
f.leader('n', 'bj', smart.swap_buf_down,  "Swap Down")
f.leader('n', 'bk', smart.swap_buf_up,    "Swap Up")
f.leader('n', 'bl', smart.swap_buf_right, "Swap Right")
