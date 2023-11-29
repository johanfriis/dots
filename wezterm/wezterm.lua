local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder() then
	config = wezterm.config_builder()
end

-------------------------------------------------------------------------------
-- {{{ // COLORS

config.color_scheme = 'rose-pine-moon'
config.colors = {
  selection_fg = '#e0def4',
  selection_bg = '#44415a',
  -- cursor_fg = '#232136',
  cursor_bg = '#908caa',
}

-- }}}

-------------------------------------------------------------------------------
-- {{{ // FONT

config.font = wezterm.font { family = 'CaskaydiaCove Nerd Font' }

config.font_rules = {
	{
		intensity = 'Bold',
		italic = false,
		font = wezterm.font {
			family = 'CaskaydiaCove Nerd Font',
			weight = 'Bold',
			style = 'Normal',
		},
	},
}

-- turn off most ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- config.cell_width = 1.05
config.font_size = 13

-- }}}

-------------------------------------------------------------------------------
-- {{{ // UI

config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.use_resize_increments = true -- resize in terminal cell size increments

-- }}}

-------------------------------------------------------------------------------
-- {{{ // KEYBINDINGS

local a = wezterm.actions
local map = require('utils').map

config.disable_default_key_bindings = true

config.keys = {
}

-- }}}

return config

---- vim: foldmethod=marker ts=2 sts=2 sw=2 et
