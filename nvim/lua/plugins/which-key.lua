-- https://github.com/folke/which-key.nvim
return {
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            local wk = require('which-key')
            wk.setup({
                show_help = false,
                -- triggers_nowait = {
                --   "<SPC>",
                --   "g",
                -- },
            })
            wk.register({
                [','] = {
                    name = 'Fastkey',
                    f = { ':Telescope find_files<CR>', 'Files' },
                },
                ['<leader>'] = {
                    b = {
                        name = 'Buffer',
                        a = { ':b#<CR>',    'Alternate' },
                        q = { ':close<CR>', 'Qlose' },
                        h = { ':lua require("smart-list").swap_buf_left()<CR>',    'Swap Left' },
                        j = { ':lua require("smart-list").swap_buf_down()<CR>',    'Swap Down' },
                        k = { ':lua require("smart-list").swap_buf_up()<CR>',      'Swap Up' },
                        l = { ':lua require("smart-list").swap_buf_right()<CR>',   'Swap Right' },
                    },
                    d = {
                        name = 'Dev',
                        g = { ':LazyGit<CR>',       'LazyGit' },
                        v = { ':lua <C-r>"<CR>',    'Eval " register' },
                    },
                    p = {
                        name = 'Pick',
                        a = { ':lua require("utils.pickers").adjacent()<CR>', 'Adjacent File' },
                        g = { ':Telescope git_files<CR>', 'Git File' },
                        s = { ':Telescope live_grep<CR>', 'Search File' },
                        r = { ':Telescope oldfiles<CR>',  'Recent File' },
                        t = { ':Telescope current_buffer_fuzzy_finder<CR>', 'This File' },
                        v = { ':Telescope help_tags<CR>', 'Vim Help' },
                    },
                    t = {
                        name = 'Toggle',
                        d = { ':lua require("utils.functions").toggle_diagnostic()<CR>', 'Toggle Diagnostic' },
                        h = { ':setlocal hlsearch!<CR>',   'Toggle `hlsearch`' },
                        i = { ':setlocal ignorecase!<CR>', 'Toggle `ignorecase`' },
                        l = { ':setlocal list!<CR>', 'Toggle `list`' },
                        n = { ':setlocal number!<CR>', 'Toggle `number`' },
                        r = { ':setlocal relativenumber!<CR>', 'Toggle `relativenumber`' },
                        s = { ':setlocal spell!<CR>', 'Toggle `spell`' },
                        w = { ':setlocal wrap!<CR>', 'Toggle `wrap`' },
                        c = { ':setlocal cursorline!<CR>', 'Toggle `cursorline`' },
                        v = { ':setlocal cursorcolumn!<CR>', 'Toggle `cursorcolumn`' },
                        x = { ':lua require("utils.functions").toggle_colorcolumn()<CR>', 'Toggle colorcolumn' },
                    },
                },
            })
        end,
    },
}


-- 
-- -- 'd' is for 'dev'
-- leader('x',          'da', [[gA]],                              '[A]lign selection')
-- leader({ 'n', 'v' }, 'dc', vim.lsp.buf.code_action,             '[C]ode Action')
-- leader({ 'n', 'v' }, 'dc', vim.lsp.buf.format,                  '[F]ormat')
-- leader('n',          'dg', [[<Cmd>LazyGit<CR>]],                '[G]it Lazy (lazygit)')
-- leader('n',          'dl', vim.diagnostic.open_float,           'F[l]oat Diagnostic')
-- leader('n',          'dr', vim.lsp.buf.rename,                  '[R]ename')
-- leader('n',          'ds', vim.lsp.buf.signature_help,          '[S]ignature help')
-- leader('n',          'dS', [[<Cmd>write<CR><Cmd>source %<CR>]], '[S]ource file')

-- leader('n', 'pb', "<Cmd>Telescope file_browser<CR>",              '[B]rowse File')
-- leader('n', 'pj', "<Cmd>Telescope whaler<CR>",                    '[J]ump Dir')
-- leader('n', 'pu', "<Cmd>Telescope undo<CR>",                      '[U]ndo Tree')
-- leader('n', 'nn', '<Cmd>Telekasten<CR>', 'Open Telekasten')

-- map('n', ',e', "<Cmd>NvimTreeToggle<CR>",            '[E]xplore Tree')
-- map('n', ',r', [[<Cmd>Trouble lsp_references<CR>]],  '[R]eferences')
-- map('n', ',d', [[<Cmd>Trouble lsp_definitions<CR>]], '[D]efinitions')

--   { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
--   { mode = 'n', keys = '<Leader>d', desc = '+Dev' },
--   { mode = 'n', keys = '<Leader>g', desc = '+Goto' },
--   { mode = 'n', keys = '<Leader>j', desc = '+Journal' },
--   { mode = 'n', keys = '<Leader>n', desc = '+Notes' },
--   { mode = 'n', keys = '<Leader>p', desc = '+Pick' },
--   { mode = 'n', keys = '<Leader>t', desc = '+Toggle' },
-- 
--   { mode = 'x', keys = '<Leader>d', desc = '+Dev' },
-- 
--   { mode = 'n', keys = ',',         desc = '+Quick' },

-- -- 'b' is for 'buffer'
-- leader('n', 'ba', [[<Cmd>b#<CR>]],      '[A]lternate')
-- leader('n', 'bs', f.new_scratch_buffer, '[S]cratch')
-- leader('n', 'bq', [[<Cmd>close<CR>]],   '[Q]uit (close)')
-- 
-- -- 'g' is for 'goto'
-- leader('n', 'gd', [[<Cmd>Trouble lsp_definitions<CR>]],     '[D]efinitions')
-- leader('n', 'gr', [[<Cmd>Trouble lsp_references<CR>]],      '[R]eferences')
-- leader('n', 'gt', [[<Cmd>Trouble lsp_type_definition<CR>]], '[T]ype')
-- 
-- -- 'j' is for 'journal'
-- leader('n', 'jc', [[<Cmd>Telekasten show_calendar<CR>]],     '[C]alendar')
-- leader('n', 'jd', [[<Cmd>Telekasten goto_today<CR>]],        '[D]aily')
-- leader('n', 'jD', [[<Cmd>Telekasten find_daily_notes<CR>]],  'Find [D]aily')
-- leader('n', 'jo', [[<Cmd>Telekasten find_notes<CR>]],        '[O]pen')
-- leader('n', 'jn', [[<Cmd>Telekasten new_note<CR>]],          '[N]ew')
-- leader('n', 'js', [[<Cmd>Telekasten search_notes<CR>]],      '[S]earch')
-- leader('n', 'jt', [[<Cmd>Telekasten show_tags<CR>]],         '[T]ags')
-- leader('n', 'jv', [[<Cmd>Telekasten switch_vault<CR>]],      '[V]ault')
-- leader('n', 'jw', [[<Cmd>Telekasten goto_thisweek<CR>]],     '[W]eekly')
-- leader('n', 'jW', [[<Cmd>Telekasten find_weekly_notes<CR>]], 'Find [W]eekly')
-- 

-- g is for git
--  leader('n', 'gA', [[<Cmd>lua require("gitsigns").stage_buffer()<CR>]],        'Add buffer')
--  leader('n', 'ga', [[<Cmd>lua require("gitsigns").stage_hunk()<CR>]],          'Add (stage) hunk')
--  leader('n', 'gb', [[<Cmd>lua require("gitsigns").blame_line()<CR>]],          'Blame line')
-- leader('n', 'gg', [[<Cmd>lua open_lazygit()<CR>]],                          'Git tab')
--  leader('n', 'gp', [[<Cmd>lua require("gitsigns").preview_hunk()<CR>]],        'Preview hunk')
--  leader('n', 'gq', [[<Cmd>lua require("gitsigns").setqflist()<CR>:copen<CR>]], 'Quickfix hunks')
--  leader('n', 'gu', [[<Cmd>lua require("gitsigns").undo_stage_hunk()<CR>]],     'Undo stage hunk')
--  leader('n', 'gx', [[<Cmd>lua require("gitsigns").reset_hunk()<CR>]],          'Discard (reset) hunk')
--  leader('n', 'gX', [[<Cmd>lua require("gitsigns").reset_buffer()<CR>]],        'Discard (reset) buffer')

-- return M

-- vim: foldmethod=marker ts=2 sts=2 sw=2 et

