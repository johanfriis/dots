local f = require('utils.functions')
local map = f.map
local leader = f.leader
local pickers = require('utils.pickers')

local M = {}
-- ============================================================================
-- mappings ===

-- fix yanking and pasting
map({'n', 'x'}, 'gy',  '"+y',  'Yank to system clipboard')
map({'n', 'x'}, 'gyy', '"+yy', 'Yank to system clipboard')
map('n',        'gp',  '"+p',  'Paste from system clipboard')

-- Paste in visual with P to not copy selected text (:h v_P)
map('x', 'gp', '"+P',   'Paste from system clipboard')
map("n", "gV", "`[v`]", 'Reselect pasted text')

-- Move by visible lines
map({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
map({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

-- Out / Indent
map({ 'x' }, '<', "<gv", { nowait = true })
map({ 'x' }, '>', ">gv", { nowait = true })

-- some readline mappings in insert and command mode
map({'i', 'c'}, '<C-b>', '<Left>',  'Left',  { silent = false })
map({'i', 'c'}, '<C-f>', '<Right>', 'Right', { silent = false })
map({'i', 'c'}, '<C-a>', '<Home>',  'Home',  { silent = false })
map({'i', 'c'}, '<C-e>', '<End>',   'End',   { silent = false })

-- Disable `s` shortcut (use `cl` instead) for safer usage of 'mini.surround'
map({'n', 'x'}, [[s]], [[<Nop>]])

-- Better command history navigation
map('c', '<C-p>', '<Up>',   { silent = false })
map('c', '<C-n>', '<Down>', { silent = false })

map('n', '§', "<Cmd>Telescope buffers<CR>", 'Buffers')

map('n', ',f', "<Cmd>Telescope find_files<CR>",      '[F]iles')
map('n', ',r', [[<Cmd>Trouble lsp_references<CR>]],  '[R]eferences')
map('n', ',d', [[<Cmd>Trouble lsp_definitions<CR>]], '[D]efinitions')

-- This is such a nice and simple way of switching buffers,
-- I have to think a bit about it.
-- nnoremap gb :buffers<CR>:buffer<Space>

-- ============================================================================
-- leader mappings ===

vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- other good group names:
-- +Code, +Explore, +Find
M.clues = {
  { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
  { mode = 'n', keys = '<Leader>d', desc = '+Dev' },
  { mode = 'n', keys = '<Leader>g', desc = '+Goto' },
  { mode = 'n', keys = '<Leader>n', desc = '+Notes' },
  { mode = 'n', keys = '<Leader>p', desc = '+Pick' },
  { mode = 'n', keys = '<Leader>t', desc = '+Toggle' },

  { mode = 'x', keys = '<Leader>d', desc = '+Dev' },

  { mode = 'n', keys = ',',         desc = '+Quick' },
}

-- 'b' is for 'buffer'
leader('n', 'ba', [[<Cmd>b#<CR>]],      '[A]lternate')
leader('n', 'bs', f.new_scratch_buffer, '[S]cratch')
leader('n', 'bq', [[<Cmd>close<CR>]],   '[Q]uit (close)')

-- 'd' is for 'dev'
leader('x',          'da', [[gA]],                     '[A]lign selection')
leader({ 'n', 'v' }, 'dc', vim.lsp.buf.code_action,    '[C]ode Action')
leader({ 'n', 'v' }, 'dc', vim.lsp.buf.format,         '[F]ormat')
leader('n',          'dg', [[<Cmd>LazyGit<CR>]],       '[G]it Lazy (lazygit)')
leader('n',          'dl', vim.diagnostic.open_float,  'F[l]oat Diagnostic')
leader('n',          'dr', vim.lsp.buf.rename,         '[R]ename')
leader('n',          'ds', vim.lsp.buf.signature_help, '[S]ignature help')
leader('n',          'dS', [[<Cmd>source %<CR>]],      '[S]ource file')

-- 'g' is for 'goto'
leader('n', 'gd', [[<Cmd>Trouble lsp_definitions<CR>]],     '[D]efinitions')
leader('n', 'gr', [[<Cmd>Trouble lsp_references<CR>]],      '[R]eferences')
leader('n', 'gt', [[<Cmd>Trouble lsp_type_definition<CR>]], '[T]ype')

-- 'p' is for 'pick'
leader('n', 'pg', '<Cmd>Telescope git_files<CR>',                 '[G]it File')
leader('n', 'pb', "<Cmd>Telescope file_browser<CR>",              '[B]rowse File')
leader('n', 'ps', "<Cmd>Telescope live_grep<CR>",                 '[S]earch File')
leader('n', 'pr', "<Cmd>Telescope oldfiles<CR>",                  '[R]ecent File')
leader('n', 'pt', "<Cmd>Telescope current_buffer_fuzzy_find<CR>", '[T]his File')
leader('n', 'pa', pickers.adjacent,                               '[A]djacent File')
leader('n', 'pj', "<Cmd>Telescope whaler<CR>",                    '[J]ump Dir')
leader('n', 'pu', "<Cmd>Telescope undo<CR>",                      '[U]ndo Tree')
leader('n', 'nn', '<Cmd>Telekasten<CR>', 'Open Telekasten')

-- 't' is for 'toggle'
leader('n', 'td',  f.toggle_diagnostic,                        'Toggle diagnostic')
leader('n', 'th',  '<Cmd>let v:hlsearch = 1 - v:hlsearch<CR>', 'Toggle search highlight')
leader('n', 'ti',  '<Cmd>setlocal ignorecase!<CR>',            "Toggle 'ignorecase'")
leader('n', 'tl',  '<Cmd>setlocal list!<CR>',                  "Toggle 'list'")
leader('n', 'tn',  '<Cmd>setlocal number!<CR>',                "Toggle 'number'")
leader('n', 'tr',  '<Cmd>setlocal relativenumber!<CR>',        "Toggle 'relativenumber'")
leader('n', 'ts',  '<Cmd>setlocal spell!<CR>',                 "Toggle 'spell'")
leader('n', 'tw',  '<Cmd>setlocal wrap!<CR>',                  "Toggle 'wrap'")
leader('n', 'tC',  f.toggle_colorcolumn,                       'Toggle colorcolumn')
leader('n', 'tcl', '<Cmd>setlocal cursorline!<CR>',            "Toggle 'cursorline'")
leader('n', 'tcc', '<Cmd>setlocal cursorcolumn!<CR>',          "Toggle 'cursorcolumn'")

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

return M

-- vim: foldmethod=marker ts=2 sts=2 sw=2 et

