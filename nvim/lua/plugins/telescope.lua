return {{
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    lazy = true,
    cmd = { "Telescope" },
    -- event = { "BufReadPre", "BufNewFile" },
    config = function (_, opts)
        local telescope = require('telescope')

        local actions = require('telescope.actions')
        local layout_actions = require('telescope.actions.layout')

        telescope.setup({
            defaults = {
                initial_mode = 'insert',
                prompt_prefix = '',
                preview = {
                    hide_on_startup = true,
                },
                mappings = {
                    i = {
                        ['<C-g>'] = actions.close,
                        ['<C-j>'] = actions.move_selection_next,
                        ['<C-k>'] = actions.move_selection_previous,
                    },
                    n = {
                        ['<C-g>'] = actions.close,
                        ['q'] = actions.close,
                        ['p'] = layout_actions.toggle_preview,
                    },
                },
            },
            pickers = {
                buffers = {
                    theme = 'dropdown',
                    initial_mode = 'normal',
                    previewer = false,
                    sort_lastused = true,
                    -- sort_mru = false,
                    -- ignore_current_buffer = true,
                    layout_config = {
                        anchor = 'N',
                        mirror = true,
                    },
                    mappings = {
                        n = {
                            ['§'] = actions.close,
                            ['d'] = actions.delete_buffer,
                            ['o'] = actions.select_default,
                        },
                    },
                },
            },
            extensions = {
                -- file_browser = {
                --     theme = 'dropdown',
                --     hijack_netrw = true,
                --     git_status = false,
                --     dir_icon = ' ',
                --     cwd_to_path = true,
                --     initial_mode = 'normal',
                --     layout_config = {
                --         height = 0.5,
                --         anchor = 'N',
                --         mirror = true,
                --     },
                -- },
                -- whaler = {
                --     auto_file_explorer = false,
                --     auto_cwd = true,
                --     -- file_explorer = 'telescope_find_files',
                --     -- file_explorer_config = {
                --     --   plugin_name = 'telescope',
                --     --   command = 'Telescope find_files',
                --     --   prefix_dir = " cwd = "
                --     -- },
                --     oneoff_directories = {
                --         { alias = 'bin',    path = f.home('dev/bin') },
                --         { alias = 'dots',   path = f.home('dev/dots') },
                --         { alias = 'notes',  path = f.home('dev/notes') },
                --         { alias = 'neovim', path = f.home('dev/dots/nvim') },
                --     },
                --     directories = {
                --         { alias = 'work',     path = f.home('work') },
                --         { alias = 'smurfs',   path = f.home('dev/smurfs') },
                --         { alias = 'projects', path = f.home('dev/projects') },
                --     },
                -- },
            },
        })
    end,
}}
