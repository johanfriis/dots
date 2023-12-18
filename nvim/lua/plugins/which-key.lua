-- https://github.com/folke/which-key.nvim

return {
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            local wk = require('which-key')
            local f = require('utils.functions')
            wk.setup({
                show_help = false,
            })
            wk.register({
                [','] = {
                    name = 'Fastkey',
                    e = { ':Explore<CR>',                 'Explore [Netrw]' },
                    f = { ':Telescope find_files<CR>',    'Files [Pick]' },
                    r = { ':Trouble lsp_references<CR>',  'References [LSP]' },
                    d = { ':Trouble lsp_definitions<CR>', 'Definitions [LSP]' },
                },
                ['<leader>'] = {
                    b = {
                        name = 'Buffer',
                        a = { ':b#<CR>',    'Alternate' },
                        h = { ':lua require("smart-list").swap_buf_left()<CR>',    'Swap Left' },
                        j = { ':lua require("smart-list").swap_buf_down()<CR>',    'Swap Down' },
                        k = { ':lua require("smart-list").swap_buf_up()<CR>',      'Swap Up' },
                        l = { ':lua require("smart-list").swap_buf_right()<CR>',   'Swap Right' },
                        s = { f.new_scratch_buffer,                                'Scratch' },
                    },
                    d = {
                        name = 'Dev',
                        c = { vim.lsp.buf.code_action,    'Code Action [LSP]' },
                        d = { vim.diagnostic.open_float,  'Diagnostics [LSP]' },
                        f = { vim.lsp.buf.format,         'Format [LSP]' },
                        g = { ':LazyGit<CR>',             'LazyGit' },
                        r = { vim.lsp.buf.rename,         'Rename [LSP]' },
                        s = { vim.lsp.buf.signature_help, 'Signature Help [LSP]' },
                        v = { ':lua <C-r>"<CR>',          'Eval " register' },
                    },
                    j = {
                      name = 'Journal',
                      c = { ':Telekasten show_calendar<CR>',     'Calendar' },
                      d = { ':Telekasten goto_today<CR>',        'Daily' },
                      D = { ':Telekasten find_daily_notes<CR>',  'Find Daily' },
                      o = { ':Telekasten find_notes<CR>',        'Open' },
                      n = { ':Telekasten new_note<CR>',          'New' },
                      s = { ':Telekasten search_notes<CR>',      'Search' },
                      t = { ':Telekasten show_tags<CR>',         'Tags' },
                      v = { ':Telekasten switch_vault<CR>',      'Vault' },
                      w = { ':Telekasten goto_thisweek<CR>',     'Weekly' },
                      W = { ':Telekasten find_weekly_notes<CR>', 'Find Weekly' },
                    },
                    p = {
                        name = 'Pick',
                        a = { ':lua require("utils.pickers").adjacent()<CR>', 'Adjacent File' },
                        g = { ':Telescope git_files<CR>',                     'Git File' },
                        s = { ':Telescope live_grep<CR>',                     'Search File' },
                        r = { ':Telescope oldfiles<CR>',                      'Recent File' },
                        t = { ':Telescope current_buffer_fuzzy_finder<CR>',   'This File' },
                        u = { ':Telescope undo<CR>',                          'Undotree' },
                        v = { ':Telescope help_tags<CR>',                     'Vim Help' },
                    },
                    t = {
                        name = 'Toggle',
                        d = { ':lua require("utils.functions").toggle_diagnostic()<CR>',  'Toggle Diagnostic' },
                        h = { ':setlocal hlsearch!<CR>',                                  'Toggle `hlsearch`' },
                        i = { ':setlocal ignorecase!<CR>',                                'Toggle `ignorecase`' },
                        l = { ':setlocal list!<CR>',                                      'Toggle `list`' },
                        n = { ':setlocal number!<CR>',                                    'Toggle `number`' },
                        r = { ':setlocal relativenumber!<CR>',                            'Toggle `relativenumber`' },
                        s = { ':setlocal spell!<CR>',                                     'Toggle `spell`' },
                        w = { ':setlocal wrap!<CR>',                                      'Toggle `wrap`' },
                        c = { ':setlocal cursorline!<CR>',                                'Toggle `cursorline`' },
                        v = { ':setlocal cursorcolumn!<CR>',                              'Toggle `cursorcolumn`' },
                        x = { ':lua require("utils.functions").toggle_colorcolumn()<CR>', 'Toggle colorcolumn' },
                    },
                },
            })
        end,
    },
}

-- vim: foldmethod=marker

