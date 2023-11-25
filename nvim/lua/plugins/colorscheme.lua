local F = require('functions')
local theme         = 'rose-pine/neovim'
local theme_name    = 'rose-pine'
local light_theme   = 'rose-pine-dawn'
local dark_theme    = 'rose-pine-moon'

local opts = {
  disable_background = true,
  highlight_groups = _G.rose_pine_highlight_groups,
}

-- {{{ Colorscheme toggler

local toggle_colorscheme = function(light, dark)
  local value = vim.api.nvim_get_option_value('background', {})
	if value == 'dark' then
		vim.api.nvim_set_option_value("background", "light", {})
		vim.cmd.colorscheme(light)
	else
		vim.api.nvim_set_option_value("background", "dark", {})
		vim.cmd.colorscheme(dark)
	end
end

local toggle = function ()
  toggle_colorscheme(light_theme, dark_theme)
end

-- }}}

local keys = {
  { '<leader>tt', toggle, desc = 'Toggle theme' }
}

-- {{{ Lazy setup

local api = vim.api
local cmd = vim.cmd
local fn  = vim.fn

local set_theme_from_system = function(boot)
  local is_boot = boot or false
  -- get the current system appearance style
  -- macOS does not store a value for Light mode, rather sets the
  -- shell status to '1', so read off of that
  fn.system({
    'defaults', 'read', '-g', 'AppleInterfaceStyle'
  })

  local system_is_light = vim.v.shell_error == 1

  if not is_boot then
    local nvim_is_light = api.nvim_get_option_value('background', {}) == 'light'

    if system_is_light == nvim_is_light then
      return
    end
  end

  if system_is_light then
    api.nvim_set_option_value('background', 'light', {})
    cmd.colorscheme(light_theme)
  else
    api.nvim_set_option_value('background', 'dark', {})
    cmd.colorscheme(dark_theme)
  end
end

local function config()

  require('rose-pine').setup(opts)
  cmd.colorscheme(dark_theme)

  --set_theme_from_system(true)

  -- F.setInterval(2000, vim.schedule_wrap(set_theme_from_system))
end

return {
  {
    theme,
    keys = keys,
    lazy = false,
    config = config,
    priority = 1000,
    name = theme_name,
  },
}
-- }}}

-- vim: foldmethod=marker
