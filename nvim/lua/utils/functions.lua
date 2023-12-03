local keymap = vim.keymap
local api    = vim.api
local cmd    = vim.cmd
local fn     = vim.fn

local M = {}


--- --------------------------------------------------------------------------
--- Quick creation of home based paths

M.home = function(path)
  return vim.fn.expand("~/" .. path)
end

--- --------------------------------------------------------------------------
--- setInterval using libuv 

M.setInterval = function (interval, callback)
  local timer = vim.uv.new_timer()
  timer:start(interval, interval, function ()
    callback()
  end)
  return timer
end


--- --------------------------------------------------------------------------
--- Make it easier to create autocmds ---

M.autocmds = function(name, autocmds)
  local group = api.nvim_create_augroup(name, {})
  for _, opts in ipairs(autocmds) do
    local events = opts.events
    opts.events = nil
    opts.group = group
    api.nvim_create_autocmd(events, opts)
  end
end


--- --------------------------------------------------------------------------
--- Make it easier to create mappings with sensible defaults ---

local default_keymap_opts = {
  noremap = true,
  silent = true,
  expr = false,
  nowait = false,
  script = false,
  unique = false
}

M.map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  if type(desc) == 'table' then
    opts = desc
  else
    opts.desc = desc
  end
  local o = vim.tbl_deep_extend('force', default_keymap_opts, opts)
  keymap.set(mode, lhs, rhs, o)
end

M.bufmap = function(mode, lhs, rhs, desc)
  local opts = { buffer = true }
  M.map(mode, lhs, rhs, desc, opts)
end


--- --------------------------------------------------------------------------
--- Create `<Leader>` mappings ---

M.leader = function(mode, suffix, rhs, desc, opts)
  M.map(mode, '<Leader>' .. suffix, rhs, desc, opts)
end


--- --------------------------------------------------------------------------
--- simple highlighting ---

--- fg (or foreground), bg (or background), sp (or special), blend,
--- bold, standout, underline, undercurl, underdouble, underdotted,
--- underdashed, strikethrough, italic, reverse, nocombine, link,
--- ctermfg, ctermbg, cterm,

M.hl = function(group, definitions)
  local groups = group
  if type(group) == 'string' then
    groups = { group }
  end

  for _, g in ipairs(groups) do
    api.nvim_set_hl(0, g, definitions or {})
  end
end


--- --------------------------------------------------------------------------
--- Toggle diagnostic for current buffer ---

--- Diagnostic state per buffer
local buffer_diagnostic_state = {}

M.toggle_diagnostic = function()
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


--- --------------------------------------------------------------------------
--- Toggle colorcolumn for current buffer ---

M.toggle_colorcolumn = function()
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


--- --------------------------------------------------------------------------
--- Action for `<CR>` which respects completion and autopairs ---

--- Mapping should be done after everything else because `<CR>` can be
--- overridden by something else (notably 'mini-pairs.lua'). This should be an
--- expression mapping:
--- vim.api.nvim_set_keymap('i', '<CR>', 'v:lua._cr_action()', { expr = true })
---
--- Its current logic:
--- - If no popup menu is visible, use "no popup keys" getter. This is where
---   autopairs plugin should be used. Like with 'nvim-autopairs'
---   `get_nopopup_keys` is simply `npairs.autopairs_cr`.
--- - If popup menu is visible:
---     - If item is selected, execute "confirm popup" action and close
---       popup. This is where completion engine takes care of snippet expanding
---       and more.
---     - If item is not selected, close popup and execute '<CR>'. Reasoning
---       behind this is to explicitly select desired completion (currently this
---       is also done with one '<Tab>' keystroke).

local cr_keys = {
  ['cr'] = api.nvim_replace_termcodes('<CR>', true, true, true),
  ['ctrl-y'] = api.nvim_replace_termcodes('<C-y>', true, true, true),
  ['ctrl-y_cr'] = api.nvim_replace_termcodes('<C-y><CR>', true, true, true),
}

M.cr_action = function()
  if vim.fn.pumvisible() ~= 0 then
    local item_selected = fn.complete_info()['selected'] ~= -1
    return item_selected and cr_keys['ctrl-y'] or cr_keys['ctrl-y_cr']
  else
    return require('mini.pairs').cr()
  end
end


--- --------------------------------------------------------------------------
--- Create scratch buffer and focus on it ---

M.new_scratch_buffer = function()
  local buf_id = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(0, buf_id)
  return buf_id
end


--- --------------------------------------------------------------------------
--- Toggle quickfix window ---

M.toggle_quickfix = function()
  local quickfix_wins = vim.tbl_filter(
  function(win_id) return fn.getwininfo(win_id)[1].quickfix == 1 end,
  api.nvim_tabpage_list_wins(0)
  )

  local command = #quickfix_wins == 0 and 'copen' or 'cclose'
  cmd(command)
end


--- --------------------------------------------------------------------------
--- Toggle LazyGit ---

M.open_lazygit = function()
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
  vim.b.minipairs_disable = true
end


--- --------------------------------------------------------------------------
--- print any number of objects ---
M.put = function(...)
  local objects = {}
  -- Not using `{...}` because it removes `nil` input
  for i = 1, select('#', ...) do
    local v = select(i, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))

  return ...
end

--- --------------------------------------------------------------------------
--- check if cursor has non-whitespace directly before it ---
M.has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

--- --------------------------------------------------------------------------

return M

--- vim: foldmethod=marker ts=2 sts=2 sw=2 et
