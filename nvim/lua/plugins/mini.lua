return {
    {
        'echasnovski/mini.align',
        version = false,
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {},
    },
    {
        'echasnovski/mini.comment',
        version = false,
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {},
    },
    {
        'echasnovski/mini.jump2d',
        version = false,
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {
            view = {
                dim = true,
            },
            labels = 'abcdefghijklmnopqrstuvwxyz',
            mappings = {
                start_jumping = '<Tab>',
            },
        },
    },
    {
        'echasnovski/mini.move',
        version = false,
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {
            mappings = {
                left = 'H',
                right = 'L',
                down = 'J',
                up = 'K',

                line_left = '',
                line_right = '',
                line_down = '',
                line_up = '',
            }
        },
    },
    {
        'echasnovski/mini.surround',
        version = false,
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {},
    },
}
