local keymap = vim.keymap
local api    = vim.api
local cmd    = vim.cmd
local fn     = vim.fn

local M = {}



-- --------------------------------------------------------------------------
-- {{{ setInterval using libuv 
M.setInterval = function (interval, callback)
  local timer = vim.uv.new_timer()
  timer:start(interval, interval, function ()
    callback()
  end)
  return timer
end
-- }}}


-- --------------------------------------------------------------------------
-- {{{ Make it easier to create augroups ---

function augroup(name, autocmds)
	local group = api.nvim_create_augroup(name, {})
	for event, opts in pairs(autocmds) do
		opts.group = group
		api.nvim_create_autocmd(event, opts)
	end
end

-- }}}


-- --------------------------------------------------------------------------
-- {{{ Make it easier to create mappings with sensible defaults ---

local default_keymap_opts = {
	noremap = true,
	silent = true,
	expr = false,
	nowait = false,
	script = false,
	unique = false
}

function map(mode, keys, cmd, opts)
	local o = vim.tbl_deep_extend('force', default_keymap_opts, opts or {})
	keymap.set(mode, keys, cmd, o)
end

-- }}}


-- --------------------------------------------------------------------------
-- {{{ simple highlighting ---

-- fg (or foreground), bg (or background), sp (or special), blend,
-- bold, standout, underline, undercurl, underdouble, underdotted,
-- underdashed, strikethrough, italic, reverse, nocombine, link,
-- ctermfg, ctermbg, cterm,

function hl(group, definitions)
	api.nvim_set_hl(0, group, definitions or {})
end
-- }}}


-- --------------------------------------------------------------------------
-- {{{ Create `<Leader>` mappings ---
--
function leader(mode, suffix, rhs, desc, opts)
	opts = opts or {}
	opts.desc = desc
	keymap.set(mode, '<Leader>' .. suffix, rhs, opts)
end
-- }}}


-- --------------------------------------------------------------------------
-- {{{ Toggle diagnostic for current buffer ---

-- Diagnostic state per buffer
local buffer_diagnostic_state = {}

_G.toggle_diagnostic = function()
	local buf_id = api.nvim_get_current_buf()
	local buf_state = buffer_diagnostic_state[buf_id]
	if buf_state == nil then buf_state = true end

	if buf_state then
		vim.diagnostic.disable(buf_id)
	else
		vim.diagnostic.enable(buf_id)
	end

	local new_buf_state = not buf_state
	buffer_diagnostic_state[buf_id] = new_buf_state

	return new_buf_state and '  diagnostic' or 'nodiagnostic'
end
-- }}}


-- --------------------------------------------------------------------------
-- {{{ Toggle colorcolumn for current buffer ---

_G.toggle_colorcolumn = function()
	--  local current_state = api.nvim_get_option_value('colorcolumn', {})
	--  local default = '+1'
	--  local on_state = H.colorcolumn_state or default
	--if buf_state ~= nil then buf_state = nil end

	if api.nvim_get_option_value('colorcolumn', {}) == '' then
		api.nvim_set_option_value('colorcolumn', '+1', {})
	else
		api.nvim_set_option_value('colorcolumn', '', {})
	end
end
-- }}}


-- --------------------------------------------------------------------------
-- {{{ Action for `<CR>` which respects completion and autopairs ---

-- Mapping should be done after everything else because `<CR>` can be
-- overridden by something else (notably 'mini-pairs.lua'). This should be an
-- expression mapping:
-- vim.api.nvim_set_keymap('i', '<CR>', 'v:lua._cr_action()', { expr = true })
--
-- Its current logic:
-- - If no popup menu is visible, use "no popup keys" getter. This is where
--   autopairs plugin should be used. Like with 'nvim-autopairs'
--   `get_nopopup_keys` is simply `npairs.autopairs_cr`.
-- - If popup menu is visible:
--     - If item is selected, execute "confirm popup" action and close
--       popup. This is where completion engine takes care of snippet expanding
--       and more.
--     - If item is not selected, close popup and execute '<CR>'. Reasoning
--       behind this is to explicitly select desired completion (currently this
--       is also done with one '<Tab>' keystroke).

local cr_cr_keys = {
	['cr'] = api.nvim_replace_termcodes('<CR>', true, true, true),
	['ctrl-y'] = api.nvim_replace_termcodes('<C-y>', true, true, true),
	['ctrl-y_cr'] = api.nvim_replace_termcodes('<C-y><CR>', true, true, true),
}

_G.cr_action = function()
	if vim.fn.pumvisible() ~= 0 then
		local item_selected = fn.complete_info()['selected'] ~= -1
		return item_selected and cr_cr_keys['ctrl-y'] or cr_keys['ctrl-y_cr']
	else
		return require('mini.pairs').cr()
	end
end

-- }}}


-- --------------------------------------------------------------------------
-- {{{ Create scratch buffer and focus on it ---

_G.new_scratch_buffer = function()
	local buf_id = vim.api.nvim_create_buf(true, true)
	vim.api.nvim_win_set_buf(0, buf_id)
	return buf_id
end

-- }}}


-- --------------------------------------------------------------------------
-- {{{ Toggle quickfix window ---

_G.toggle_quickfix = function()
	local quickfix_wins = tbl_filter(
	function(win_id) return fn.getwininfo(win_id)[1].quickfix == 1 end,
	api.nvim_tabpage_list_wins(0)
	)

	local command = #quickfix_wins == 0 and 'copen' or 'cclose'
	cmd(command)
end

-- }}}


-- --------------------------------------------------------------------------
-- {{{ Toggle LazyGit ---

_G.open_lazygit = function()
	cmd [[tabedit]]
	cmd [[setlocal nonumber signcolumn=no]]

	-- Unset vim environment variables to be able to call `vim` without errors
	-- Use custom `--git-dir` and `--work-tree` to be able to open inside
	-- symlinked submodules
	fn.termopen('VIMRUNTIME= VIM= lazygit --git-dir=$(git rev-parse --git-dir) --work-tree=$(realpath .)', {
		on_exit = function()
			cmd [[silent! :checktime]]
			cmd [[ silent! :bw ]]
		end,
	})
	cmd [[startinsert]]
	b.minipairs_disable = true
end

-- }}}

return M

-- vim: foldmethod=marker ts=2 sts=2 sw=2 et
