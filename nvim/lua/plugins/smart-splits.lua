-- https://github.com/mrjones2014/smart-splits.nvim
return {
    {
        'mrjones2014/smart-splits.nvim',
        lazy = false,
        opts = {},
        config = function(_, opts)
            local smart = require('smart-splits')
            smart.setup(opts)

            local map = require('utils.functions').map

            map('n', '<C-h>', smart.move_cursor_left)
            map('n', '<C-j>', smart.move_cursor_down)
            map('n', '<C-k>', smart.move_cursor_up)
            map('n', '<C-l>', smart.move_cursor_right)

            map('n', '<A-h>', smart.resize_left)
            map('n', '<A-j>', smart.resize_down)
            map('n', '<A-k>', smart.resize_up)
            map('n', '<A-l>', smart.resize_right)
        end,
    },
}
