local f = require('utils.functions')
local p = require('utils.pack')
local palette = require('rose-pine.palette')

p.add({
  'plenary',
  'telescope-file-browser',
  'whaler',
  'telescope-undo'
})

local telescope = require('telescope')
local builtin = require('telescope.builtin')
local themes = require('telescope.themes')
-- local extensions = require('telescope.extensions')
local actions = require('telescope.actions')
local layout_actions = require('telescope.actions.layout')


-------------------------------------------------------------------------------
--- Mappings

-------------------------------------------------------------------------------
--- Highlights

f.hl('TelescopeNormal',         { fg = palette.subtle, bg = palette.base })
f.hl('TelescopeBorder',         { fg = palette.iris,   bg = palette.base })
f.hl('TelescopePromptBorder',   { fg = palette.iris,   bg = palette.base })
f.hl('TelescopeResultsBorder',  { fg = palette.iris,   bg = palette.base })
f.hl('TelescopePreviewBorder',  { fg = palette.iris,   bg = palette.base })

f.hl('TelescopeSelection',      { fg = palette.love,   bg = palette.highlight_low })
f.hl('TelescopeSelectionCaret', { fg = palette.love })
f.hl('TelescopeMultiSelection', { fg = palette.pine })

f.hl('TelescopeMatching',       { fg = palette.love,   bg = palette.highlight_low })
f.hl('TelescopePromptPrefix',   { fg = palette.love,   bg = palette.highlight_low })
f.hl('TelescopePromptNormal',   { bg = palette.base })

-------------------------------------------------------------------------------
--- Setup

telescope.setup({
  defaults = {
    initial_mode = 'insert',
    prompt_prefix = '',
    preview = {
      hide_on_startup = true,
    },
    mappings = {
      i = {
        ['<C-g>'] = actions.close,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
      },
      n = {
        ['<C-g>'] = actions.close,
        ['q'] = actions.close,
        ['p'] = layout_actions.toggle_preview,
      },
    },
  },
  pickers = {
    buffers = {
      theme = 'dropdown',
      initial_mode = 'normal',
      previewer = false,
      sort_lastused = true,
      -- sort_mru = false,
      -- ignore_current_buffer = true,
      layout_config = {
        anchor = 'N',
        mirror = true,
      },
      mappings = {
        n = {
          ['§'] = actions.close,
          ['d'] = actions.delete_buffer,
          ['o'] = actions.select_default,
        },
      },
    },
  },
  extensions = {
    file_browser = {
      theme = 'dropdown',
      hijack_netrw = true,
      git_status = false,
      dir_icon = ' ',
      cwd_to_path = true,
      initial_mode = 'normal',
      layout_config = {
        height = 0.5,
        anchor = 'N',
        mirror = true,
      },
    },
    whaler = {
      auto_file_explorer = false,
      auto_cwd = true,
      -- file_explorer = 'telescope_find_files',
      -- file_explorer_config = {
      --   plugin_name = 'telescope',
      --   command = 'Telescope find_files',
      --   prefix_dir = " cwd = "
      -- },
      oneoff_directories = {
        { alias = 'bin',    path = f.home('dev/bin') },
        { alias = 'dots',   path = f.home('dev/dots') },
        { alias = 'notes',  path = f.home('dev/notes') },
        { alias = 'neovim', path = f.home('dev/dots/nvim') },
      },
      directories = {
        { alias = 'work',     path = f.home('work') },
        { alias = 'smurfs',   path = f.home('dev/smurfs') },
        { alias = 'projects', path = f.home('dev/projects') },
      },
    },
    undo = {

    },
  },
})

telescope.load_extension('file_browser')

-- https://github.com/salorak/whaler.nvim
telescope.load_extension('whaler')
-- https://github.com/debugloop/telescope-undo.nvim
telescope.load_extension('undo')

---- vim: foldmethod=marker ts=2 sts=2 sw=2 et
