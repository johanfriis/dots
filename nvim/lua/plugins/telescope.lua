local f = require('utils.functions')
local p = require('utils.pack')
local palette = require('rose-pine.palette')

p.add({
  'plenary',
  'telescope-file-browser',
  'whaler',
})

local telescope = require('telescope')
-- local builtin = require('telescope.builtin')
-- local extensions = require('telescope.extensions')
local actions = require('telescope.actions')
local layout_actions = require('telescope.actions.layout')


-------------------------------------------------------------------------------
--- Mappings

f.map('n', '§',     "<Cmd>Telescope buffers<CR>")
f.map('n', '<Tab>', "<Cmd>Telescope find_files<CR>")

f.leader('n', 'e', "<Cmd>Telescope file_browser<CR>")

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
        { alias = 'Dots', path = f.home('dev/dots') },
        { alias = 'Neovim', path = f.home('dev/dots/nvim') },
      },
      directories = {
        f.home('dev/work'),
        f.home('dev/smurfs'),
        f.home('dev/projects'),
      },
    },
  },
})

telescope.load_extension('file_browser')

-- https://github.com/salorak/whaler.nvim
telescope.load_extension('whaler')

---- vim: foldmethod=marker ts=2 sts=2 sw=2 et
