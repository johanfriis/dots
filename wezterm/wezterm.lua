local wez = require 'wezterm'
local act = wez.action

local config = wez.config_builder()

if wez.config_builder() then
	config = wez.config_builder()
end

-------------------------------------------------------------------------------
-- {{{ // COLORS

-- local colors = require('rose-pine').moon
-- config.color_scheme = 'rose-pine-moon'
local local_config = require('local')
local colors = local_config.get_colors()
config.color_scheme = local_config.get_colorscheme()

config.colors = {
  selection_fg = '#e0def4',
  selection_bg = '#44415a',
  cursor_fg = colors.surface,
  cursor_bg = colors.subtle,
  tab_bar = {
    background = colors.base,
    active_tab = {
      bg_color = colors.base,
      fg_color = colors.iris,
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = colors.base,
      fg_color = colors.subtle,
    },
    inactive_tab_hover = {
      bg_color = colors.base,
      fg_color = colors.text,
    },
  },
}

config.command_palette_font_size = 15
config.command_palette_fg_color = colors.text
config.command_palette_bg_color = colors.surface

config.char_select_font_size = 15
config.char_select_fg_color = colors.love
config.char_select_bg_color = "#990000"

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.8,
}

-- }}}

-------------------------------------------------------------------------------
-- {{{ // FONT

local fira_code_features = {
  'ss01', -- r
  'zero', -- 0
  'cv14', -- 3
  -- 'ss05', -- @
  'ss04', -- $
  -- 'cv18', -- %
  'ss03', -- &
  'cv16', -- *
  -- 'cv17', -- ~
  'cv29', -- {}
  'cv30', -- |
  'cv31', -- ()

  'ss02', -- <= >=
  'ss08', -- == === != !==
  'cv24', -- /=
  'ss09', -- >>= <<= ||= |=
  'cv25', -- .-
  'cv26', -- :-
  'cv32', -- .=
  'cv27', -- []
  'cv28', -- {. .}
  'ss06', -- \\
  'ss07', -- =~ !~
  -- 'ss10', -- Fl Tl fi fj fl ft
}

-- https://github.com/tonsky/FiraCode
config.font = wez.font_with_fallback({
  {
    family = 'Fira Code',
    weight = 450,
    harfbuzz_features = fira_code_features,
    assume_emoji_presentation = false,
  },
  -- fall back to symbols nerd font
  "Symbols Nerd Font Mono"
})

config.font_size = 12.8
config.adjust_window_size_when_changing_font_size = false

-- tweak spacing
config.cell_width = 0.90
-- config.line_height = 0.96

config.underline_position = -5

config.font_rules = {
	{
		intensity = 'Bold',
		italic = false,
		font = wez.font {
			family = 'Fira Code',
			weight = 900,
      harfbuzz_features = fira_code_features,
		},
	},
	{
		intensity = 'Normal',
		italic = true,
		font = wez.font {
			family = 'Fira Code',
			weight = 500,
      style = 'Italic',
      harfbuzz_features = fira_code_features,
		},
	},
}

-- I did not see any meaningful effect of these settings
-- config.front_end = 'WebGpu'
-- config.freetype_load_target = 'Light'
-- config.freetype_load_flags = 'NO_HINTING'

-- }}}

-------------------------------------------------------------------------------
-- {{{ // UI & GENERAL

-- initial sizing
config.initial_cols = 210
config.initial_rows = 64

-- don't show title bar but have resize handles
config.window_decorations = 'RESIZE'

 -- resize in terminal cell size increments?
config.use_resize_increments = false

config.window_padding = {
  left = 20,
  right = 20,
  top = 46, -- this give fullscreen a padding to match top cutout
  bottom = 0,
}

config.default_workspace = 'main'
config.scrollback_lines = 50000

config.command_palette_rows = 14

-- }}}

-------------------------------------------------------------------------------
-- {{{ // TAB BAR

-- config.enable_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

config.show_tab_index_in_tab_bar = true -- resize in terminal cell size increments
config.show_new_tab_button_in_tab_bar = false -- resize in terminal cell size increments
config.tab_max_width = 18 -- resize in terminal cell size increments

function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane in that tab
  return tab_info.active_pane.title
end

wez.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local title = wez.truncate_right(tab_title(tab), max_width - 2)

    return {
      { Text = ' ' },
      { Text = title },
      { Foreground = { Color = colors.subtle } },
      { Text = '  ' },
    }
  end
)

-- }}}

-------------------------------------------------------------------------------
-- {{{ // EVENTS

-- use this as a hack to bring the tab bar in line with the first and last
-- column of terminal text, controlled by side padding
wez.on('update-status', function(window, _) -- window, pane

  local active_tab = window:active_tab()
  local pane_infos = active_tab:panes_with_info()
  local active_pane = {}

  for _, pane in ipairs(pane_infos) do
    if pane.is_active == true then
      active_pane = pane
    end
  end

  window:set_left_status(' ')

  -- show the name of the active workspace
  local right_status = {
    { Foreground = { Color = colors.rose }},
    { Text = window:active_workspace() },
    { Text = '  ' },
  }

  -- show the name of any active key tables
  local active_key_table = window:active_key_table()
  if active_key_table then
    table.insert(right_status, 1, { Text = ' } ' })
    table.insert(right_status, 1, { Text = active_key_table })
    table.insert(right_status, 1, { Text = '{ ' })
    table.insert(right_status, 1, { Foreground = { Color = colors.gold }})
  end

  -- show a message if current pane is zoomed
  if active_pane.is_zoomed then
    print(" I MA SOOOEMED")
    table.insert(right_status, 1, { Text = '( zoomed ) ' })
    table.insert(right_status, 1, { Foreground = { Color = colors.love }})
  end

  window:set_right_status(wez.format(right_status))
end)

-- }}}

-------------------------------------------------------------------------------
-- {{{ // KEYBINDINGS

config.leader = { key = 's', mods = 'CTRL'}
config.disable_default_key_bindings = true

local keys = {}
local utils = require('utils')
local map = utils.map(keys)

local here = { domain = 'CurrentPaneDomain' }


map('c', 'SUPER',        act.CopyTo "Clipboard")
map('v', 'SUPER',        act.PasteFrom "Clipboard")

map('-', 'SUPER',        act.DecreaseFontSize)
map('=', 'SUPER',        act.IncreaseFontSize)
map('0', 'SUPER',        act.ResetFontSize)

map('p', 'SUPER',        act.ActivateCommandPalette)

-- map('n', 'LEADER',       a.SpawnWindow)
map('d', 'LEADER',       act.CloseCurrentPane { confirm = true } )

map('n', 'LEADER',       act.SpawnTab "CurrentPaneDomain")
map('n', 'CTRL|LEADER',  act.ActivateKeyTable { name = 'move_tab', one_shot = false })
map('n', 'SHIFT|LEADER', act.ShowLauncherArgs { flags = 'TABS' })
map('n', 'SUPER|LEADER', act.SpawnWindow)

map('-', 'LEADER',       act.SplitHorizontal(here))
map('_', 'LEADER',       act.SplitVertical(here))
map('=', 'LEADER',       act.RotatePanes('Clockwise'))
map('+', 'LEADER',       act.RotatePanes('CounterClockwise'))

map('m', 'CTRL|LEADER',  act.ActivateKeyTable { name = 'resize_pane', one_shot = false })


map('a',          'LEADER',      act.ActivateLastTab)
map('h',          'CTRL|LEADER', act.ActivateTabRelative(-1))
map('l',          'CTRL|LEADER', act.ActivateTabRelative(1))
map('j',          'CTRL|LEADER', act.SwitchWorkspaceRelative(1))
map('k',          'CTRL|LEADER', act.SwitchWorkspaceRelative(-1))
map('LeftArrow',  'CTRL|SUPER', act.ActivateTabRelative(-1))
map('RightArrow', 'CTRL|SUPER', act.ActivateTabRelative(1))
map('DownArrow',  'CTRL|SUPER', act.SwitchWorkspaceRelative(1))
map('UpArrow',    'CTRL|SUPER', act.SwitchWorkspaceRelative(-1))

map('p', 'LEADER',       act.PaneSelect { mode = 'Activate' })
map('p', 'CTRL|LEADER',  act.PaneSelect { mode = 'SwapWithActive' })
map('p', 'SHIFT|LEADER', act.PaneSelect { mode = 'MoveToNewTab' })

map('1', 'LEADER',       act.ActivateTab(0))
map('2', 'LEADER',       act.ActivateTab(1))
map('3', 'LEADER',       act.ActivateTab(2))
map('4', 'LEADER',       act.ActivateTab(3))

-- map('w', 'LEADER',       act.SwitchToWorkspace)
map('w', 'LEADER',       act.ShowLauncherArgs { flags = 'WORKSPACES' })

map('z', 'LEADER',       act.TogglePaneZoomState)
map(':', 'LEADER',       act.CharSelect)
map('c', 'LEADER',       act.ActivateCopyMode)
map('c', 'SHIFT|LEADER', act.QuickSelect)
map('/', 'LEADER',       act.Search { CaseSensitiveString = "" })
map('f', 'LEADER',       act.ToggleFullScreen)

map('r', 'LEADER',       utils.RenameTab)
map('r', 'CTRL|LEADER',  utils.RenameWorkspace)

map('.', 'LEADER',       act.ShowDebugOverlay)
-- map('r', 'LEADER',       a.ReloadConfiguration)


local split_nav = require('smart-splits').split_nav

-- move between split panes
split_nav(keys, 'move', 'h', 'Left')
split_nav(keys, 'move', 'j', 'Down')
split_nav(keys, 'move', 'k', 'Up')
split_nav(keys, 'move', 'l', 'Right')
-- resize panes
split_nav(keys, 'resize', 'h', 'Left')
split_nav(keys, 'resize', 'j', 'Down')
split_nav(keys, 'resize', 'k', 'Up')
split_nav(keys, 'resize', 'l', 'Right')

split_nav(keys, 'move',   'LeftArrow',  'Left')
split_nav(keys, 'move',   'DownArrow',  'Down')
split_nav(keys, 'move',   'UpArrow',    'Up')
split_nav(keys, 'move',   'RightArrow', 'Right')
-- resize panes
split_nav(keys, 'resize', 'LeftArrow',  'Left')
split_nav(keys, 'resize', 'DownArrow',  'Down')
split_nav(keys, 'resize', 'UpArrow',    'Up')
split_nav(keys, 'resize', 'RightArrow', 'Right')

config.key_tables = {
  move_tab = {
    { key = 'h', action = act.MoveTabRelative(-1)},
    { key = 'l', action = act.MoveTabRelative(1)},
    { key = 'LeftArrow', action = act.MoveTabRelative(-1)},
    { key = 'RightArrow', action = act.MoveTabRelative(1)},

    -- Cancel the mode by pressing escape
    { key = 'q',      action = 'PopKeyTable' },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'Enter',  action = 'PopKeyTable' },
  },

  resize_pane = {
    { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },
    { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },

    -- Cancel the mode by pressing escape
    { key = 'q',      action = 'PopKeyTable' },
    { key = 'Escape', action = 'PopKeyTable' },
    { key = 'Enter',  action = 'PopKeyTable' },
  },

}

config.keys = keys

-- }}}


return config

-- vim: foldmethod=marker ts=2 sts=2 sw=2 et
