local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder() then
	config = wezterm.config_builder()
end

-- // COLOR SCHEME

local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return 'Dark'
end

local function scheme_for_appearance(appearance)
	if appearance:find 'Dark' then
		return 'rose-pine-moon'
	else
		return 'rose-pine-dawn'
	end
end

local function colors_for_appearance(appearance)
	if appearance:find 'Dark' then
		return {
			selection_fg = '#e0def4',
			selection_bg = '#44415a'
		}
	else
		return {
			selection_fg = '#575279',
			selection_bg = '#cecacd'
		}
	end
end

config.color_scheme = scheme_for_appearance(get_appearance())
config.colors = colors_for_appearance(get_appearance())

--config.color_scheme = 'rose-pine-moon'
config.colors = {
  selection_fg = '#e0def4',
  selection_bg = '#44415a'
}


-- // FONT
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


-- // UI
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.use_resize_increments = true -- resize in terminal cell size increments

config.keys = {
	-- Turn off the default CMD-m Hide action, allowing CMD-m to
	-- be potentially recognized and handled by the tab
	{
		key = 'm',
		mods = 'CMD',
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = 'h',
		mods = 'CMD',
		action = wezterm.action.DisableDefaultAssignment,
	},
	-- open t - tmux smart session manager
	{
		key = 'j',
		mods = 'CMD',
		action = wezterm.action.SendString '\x13\x74'
	},
}



return config
