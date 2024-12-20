-- https://github.com/renerocksai/telekasten.nvim

local notes = vim.fn.expand('~/dev/notes')
local weeklies = notes .. '/log'

return {
    {
        'renerocksai/telekasten.nvim',
        lazy = true,
        cmd = { 'Telekasten' },
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
        },
        opts = {
            home = notes,
            command_palette_theme = 'dropdown',
            show_tags_theme = 'get_cursor',
            with_live_grep = true,
            weeklies = weeklies .. '/' .. os.date('%Y'),
            template_new_weekly = '.templates/weekly.md',
            calendar_opts = {
                weeknm = 1, --> WK01
            },

            install_syntax = false,
            take_over_my_home = false,
            auto_set_filetype = false,
            auto_set_syntax = false,
        }
    },
}
