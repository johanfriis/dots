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
        'echasnovski/mini.pairs',
        version = false,
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {},
    },
    {
        'echasnovski/mini.surround',
        version = false,
        event = { 'BufReadPre', 'BufNewFile' },
        opts = {},
    },
}
