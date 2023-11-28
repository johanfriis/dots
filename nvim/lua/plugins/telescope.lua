local f = require('utils.functions')
local p = require('utils.pack')

p.add({
  'plenary',
  'telescope-file-browser'
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
  },
})

telescope.load_extension('file_browser')
