local H = {}

-- ---------------------------------------------------------------------------
-- Make it easier to create augroups -----------------------------------------
--
function augroup(name, autocmds)
  local group = api.nvim_create_augroup(name, {})
  for event, opts in pairs(autocmds) do
    opts.group = group
    api.nvim_create_autocmd(event, opts)
  end
end


-- ---------------------------------------------------------------------------
-- Make it easier to create mappings with sensible defaults ------------------
--
local default_keymap_opts = {
  noremap = true,
  silent = true,
  expr = false,
  nowait = false,
  script = false,
  unique = false
}

function map(mode, keys, cmd, opts)
  local o = tbl_deep_extend('force', default_keymap_opts, opts or {})
  keymap.set(mode, keys, cmd, o)
end



-- ---------------------------------------------------------------------------
-- Create `<Leader>` mappings ------------------------------------------------
--
function leader(mode, suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  keymap.set(mode, '<Leader>' .. suffix, rhs, opts)
end


-- ---------------------------------------------------------------------------
-- Colorscheme toggler ------------------------------------------------
--
function toggle_colorscheme(light, dark)
  print('I am switching color')
  if opt.background == "dark" then
    api.nvim_set_option("background", "light")
    cmd.colorscheme(light)
  else
    api.nvim_set_option("background", "dark")
    cmd.colorscheme(dark)
  end
end

-- ---------------------------------------------------------------------------
-- Toggle diagnostic for current buffer- -------------------------------------
--

-- Diagnostic state per buffer
H.buffer_diagnostic_state = {}

function toggle_diagnostic ()
  local buf_id = api.nvim_get_current_buf()
  local buf_state = H.buffer_diagnostic_state[buf_id]
  if buf_state == nil then buf_state = true end

  if buf_state then
    diagnostic.disable(buf_id)
  else
    diagnostic.enable(buf_id)
  end

  local new_buf_state = not buf_state
  H.buffer_diagnostic_state[buf_id] = new_buf_state

  return new_buf_state and '  diagnostic' or 'nodiagnostic'
end

-- ---------------------------------------------------------------------------
-- Toggle colorcolumn for current buffer- -------------------------------------
--

function toggle_colorcolumn ()
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



-- vim: fdm=marker sw=2 ts=2 sts=2 et
