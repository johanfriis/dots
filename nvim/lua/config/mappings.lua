local map = require('utils.functions').map
local leader = require('utils.functions').leader
local pickers = require('utils.pickers')

-- ============================================================================
-- mappings ===

-- fix yanking and pasting
map({'n', 'x'}, 'gy', '"+y', { desc = 'Yank to system clipboard' })
map({'n', 'x'}, 'gyy', '"+yy', { desc = 'Yank to system clipboard' })
map('n', 'gp', '"+p', { desc = 'Paste from system clipboard' })

-- Paste in visual with P to not copy selected text (:h v_P)
map('x', 'gp', '"+P', { desc = 'Paste from system clipboard' })
map("n", "gV", "`[v`]", { desc = 'Reselect pasted text' })

-- Move by visible lines
map({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

-- Out / Indent
map({ 'x' }, '<', "<gv", { nowait = true })
map({ 'x' }, '>', ">gv", { nowait = true })

-- some readline mappings in insert and command mode
map({'i', 'c'}, '<C-b>', '<Left>',  { silent = false, desc = 'Left' })
map({'i', 'c'}, '<C-f>', '<Right>', { silent = false, desc = 'Right' })
map({'i', 'c'}, '<C-a>', '<Home>',  { silent = false, desc = 'Home' })
map({'i', 'c'}, '<C-e>', '<End>',   { silent = false, desc = 'End' })

-- Disable `s` shortcut (use `cl` instead) for safer usage of 'mini.surround'
map({'n', 'x'}, [[s]], [[<Nop>]])

-- Better command history navigation
map('c', '<C-p>', '<Up>', { silent = false })
map('c', '<C-n>', '<Down>', { silent = false })


-- delegate 'CR' to a customer function
--map('i', '<CR>', cr_action)

-- show Lexplore
-- map('n', '§', '<CMD>Lexplore<CR>')


map('n', '§',     "<Cmd>Telescope buffers<CR>")
map('n', '<Tab>', "<Cmd>Telescope find_files<CR>")


-- ============================================================================
-- leader mappings ===

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

leader('n', 'gg', '<Cmd>LazyGit<CR>', 'Open LazyGit')

leader('n', 'pg', '<Cmd>Telescope git_files<CR>',                 '[G]it File')
leader('n', 'pb', "<Cmd>Telescope file_browser<CR>",              '[B]rowse File')
leader('n', 'ps', "<Cmd>Telescope live_grep<CR>",                 '[S]earch File')
leader('n', 'pr', "<Cmd>Telescope oldfiles<CR>",                  '[R]ecent File')
leader('n', 'pt', "<Cmd>Telescope current_buffer_fuzzy_find<CR>", '[T]his File')
leader('n', 'pa', pickers.adjacent,                               '[A]djacent File')
leader('n', 'pj', "<Cmd>Telescope whaler<CR>",                    '[J]ump Dir')
leader('n', 'pu', "<Cmd>Telescope undo<CR>",                      '[U]ndo Tree')

-- 'b' is for 'buffer'
-- leader('n', 'ba', [[<Cmd>b#<CR>]],                                 'Alternate')
-- leader('n', 'bd', [[<Cmd>lua MiniBufremove.delete()<CR>]],         'Delete')
-- leader('n', 'bD', [[<Cmd>lua MiniBufremove.delete(0, true)<CR>]],  'Delete!')
-- leader('n', 'bs', [[<Cmd>lua new_scratch_buffer()<CR>]],           'Scratch')
-- leader('n', 'bw', [[<Cmd>lua MiniBufremove.wipeout()<CR>]],        'Wipeout')
-- leader('n', 'bW', [[<Cmd>lua MiniBufremove.wipeout(0, true)<CR>]], 'Wipeout!')

-- 'c' is for 'code'

-- 't' is for 'toggle'
leader('n', 'td',  '<Cmd>lua toggle_diagnostic()<CR>',         'Toggle diagnostic')
leader('n', 'th',  '<Cmd>let v:hlsearch = 1 - v:hlsearch<CR>', 'Toggle search highlight')
leader('n', 'ti',  '<Cmd>setlocal ignorecase!<CR>',            "Toggle 'ignorecase'")
leader('n', 'tl',  '<Cmd>setlocal list!<CR>',                  "Toggle 'list'")
leader('n', 'tn',  '<Cmd>setlocal number!<CR>',                "Toggle 'number'")
leader('n', 'tr',  '<Cmd>setlocal relativenumber!<CR>',        "Toggle 'relativenumber'")
leader('n', 'ts',  '<Cmd>setlocal spell!<CR>',                 "Toggle 'spell'")
leader('n', 'tw',  '<Cmd>setlocal wrap!<CR>',                  "Toggle 'wrap'")
leader('n', 'tC',  '<Cmd>lua toggle_colorcolumn()<CR>',        'Toggle colorcolumn')
leader('n', 'tcl', '<Cmd>setlocal cursorline!<CR>',            "Toggle 'cursorline'")
leader('n', 'tcc', '<Cmd>setlocal cursorcolumn!<CR>',          "Toggle 'cursorcolumn'")


-- 'e' is for 'explore'
-- leader('n', 'ed', [[<Cmd>lua MiniFiles.open()<CR>]],                             'Directory')
-- leader('n', 'ef', [[<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>]], 'File directory')
-- -- TODO maybe we don't want this one?
-- leader('n', 'el', [[<Cmd>lua MiniFiles.open('~/dev/notes/log')<CR>]],            'ZK Logs')
-- leader('n', 'eq', [[<Cmd>lua _G.toggle_quickfix()<CR>]],                         'Quickfix')
--
-- -- 'f' is for 'fuzzy find'
-- leader('n', 'f/', [[<Cmd>Pick history scope='/'<CR>]],                             '"/" history')
-- leader('n', 'f:', [[<Cmd>Pick history scope=':'<CR>]],                             '":" history')
-- leader('n', 'fa', [[<Cmd>Pick git_hunks scope='staged'<CR>]],                      'Added hunks (all)')
-- leader('n', 'fA', [[<Cmd>Pick git_hunks path='%' scope='staged'<CR>]],             'Added hunks (current)')
-- leader('n', 'fb', [[<Cmd>Pick buffers<CR>]],                                       'Open buffers')
-- leader('n', 'fc', [[<Cmd>Pick git_commits choose_type='show_patch'<CR>]],          'Commits')
-- leader('n', 'fC', [[<Cmd>Pick git_commits path='%' choose_type='show_patch'<CR>]], 'Buffer commits')
-- leader('n', 'fd', [[<Cmd>Pick diagnostic scope='all'<CR>]],                        'Diagnostic workspace')
-- leader('n', 'fD', [[<Cmd>Pick diagnostic scope='current'<CR>]],                    'Diagnostic buffer')
-- leader('n', 'ff', [[<Cmd>Pick files<CR>]],                                         'Files')
-- leader('n', 'fg', [[<Cmd>Pick grep_live<CR>]],                                     'Grep live')
-- leader('n', 'fG', [[<Cmd>Pick grep pattern='<cword>'<CR>]],                        'Grep current word')
-- leader('n', 'fh', [[<Cmd>Pick help<CR>]],                                          'Help tags')
-- leader('n', 'fH', [[<Cmd>Pick hl_groups<CR>]],                                     'Highlight groups')
-- leader('n', 'fl', [[<Cmd>Pick buf_lines scope='all'<CR>]],                         'Lines (all)')
-- leader('n', 'fL', [[<Cmd>Pick buf_lines scope='current'<CR>]],                     'Lines (current)')
-- leader('n', 'fm', [[<Cmd>Pick git_hunks<CR>]],                                     'Modified hunks (all)')
-- leader('n', 'fM', [[<Cmd>Pick git_hunks path='%'<CR>]],                            'Modified hunks (current)')
-- leader('n', 'fo', [[<Cmd>Pick oldfiles<CR>]],                                      'Old files')
-- leader('n', 'fO', [[<Cmd>Pick options<CR>]],                                       'Options')
-- leader('n', 'fr', [[<Cmd>Pick resume<CR>]],                                        'Resume')
-- leader('n', 'fR', [[<Cmd>Pick lsp scope='references'<CR>]],                        'References (LSP)')
-- leader('n', 'fs', [[<Cmd>Pick lsp scope='workspace_symbol'<CR>]],                  'Symbols workspace (LSP)')
-- leader('n', 'fS', [[<Cmd>Pick lsp scope='document_symbol'<CR>]],                   'Symbols buffer (LSP)')
-- TODO add a picker for TODO / FIXME / etc ...

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

-- l is for 'LSP' (Language Server Protocol)
leader('n', 'la', [[<Cmd>lua vim.lsp.buf.signature_help()<CR>]], 'Arguments popup')
leader('n', 'ld', [[<Cmd>lua vim.diagnostic.open_float()<CR>]],  'Diagnostics popup')
leader('n', 'lf', [[<Cmd>lua vim.lsp.buf.formatting()<CR>]],     'Format')
leader('n', 'li', [[<Cmd>lua vim.lsp.buf.hover()<CR>]],          'Information')
leader('n', 'lj', [[<Cmd>lua vim.diagnostic.goto_next()<CR>]],   'Next diagnostic')
leader('n', 'lk', [[<Cmd>lua vim.diagnostic.goto_prev()<CR>]],   'Prev diagnostic')
leader('n', 'lR', [[<Cmd>lua vim.lsp.buf.references()<CR>]],     'References')
leader('n', 'lr', [[<Cmd>lua vim.lsp.buf.rename()<CR>]],         'Rename')
leader('n', 'ls', [[<Cmd>lua vim.lsp.buf.definition()<CR>]],     'Source definition')

leader('x', 'lf', [[<Cmd>lua vim.lsp.buf.format()<CR><Esc>]],    'Format selection')

-- vim: foldmethod=marker ts=2 sts=2 sw=2 et
