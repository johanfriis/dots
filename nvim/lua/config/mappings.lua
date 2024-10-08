local map = require('utils.functions').map

vim.g.mapleader = ' '

--- ============================================================================
--- core mappings ===

-- easy move to previous buffer
map('n', '<leader><leader>', '<C-^>', 'Switch to previous buffer')

-- fix yanking and pasting - see (:h v_P) for explanation of second last map
map({'n', 'x'}, 'gy', '"+y',   'Yank to system clipboard')
map('n',        'gp', '"+p',   'Paste from system clipboard')
map('x',        'gp', '"+P',   'Paste from system clipboard')
map("n",        "gV", "`[v`]", 'Reselect pasted text')

-- move by visual lines
map('n', 'j', 'gj')
map('n', 'k', 'gk')

-- In / Outdent
map({ 'x' }, '<', "<gv", { nowait = true })
map({ 'x' }, '>', ">gv", { nowait = true })

-- some readline mappings in insert and command mode
map({'i', 'c'}, '<C-b>', '<Left>',  'Left',  { silent = false })
map({'i', 'c'}, '<C-f>', '<Right>', 'Right', { silent = false })
map({'i', 'c'}, '<C-a>', '<Home>',  'Home',  { silent = false })
map({'i', 'c'}, '<C-e>', '<End>',   'End',   { silent = false })

-- Disable `s` shortcut (use `cl` instead), allowing `s` for "surround"
map({'n', 'x'}, [[s]], [[<Nop>]])

-- Use C-p/n for navigating command history
map('c', '<C-p>', '<Up>',   { silent = false })
map('c', '<C-n>', '<Down>', { silent = false })

-- I want to be able to hit Esc in terminal mode
map("t",        "<Esc>", "<C-\\><C-n>", 'Exit Terminal mode')

-- This is such a nice and simple way of switching buffers,
-- I have to think a bit about whether I want to use it.
-- nnoremap gb :buffers<CR>:buffer<Space>
-- map('n', 'gb', ':buffers<CR>:buffer<Space>',   'Show buffers')

--- ============================================================================
--- fix some mappings ===

-- tab is mapped to mini.jump2d, so make sure to map <C-i> first
map('n', '<C-i>', '<C-i>')

--- ============================================================================
--- tool mappings ===

map('n', '`', ':lua require("telescope.builtin").buffers()<CR>')

-- vim: foldmethod=marker

