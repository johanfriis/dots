local f = require('utils.functions')
local p = require('utils.pack')

p.add('plenary')

local telescope = require('telescope')
local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local layout_actions = require('telescope.actions.layout')

-------------------------------------------------------------------------------
--- Helpers

local find_files = function()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  if vim.v.shell_error == 0 then
    builtin.git_files()
  else
    builtin.find_files()
  end
end


-------------------------------------------------------------------------------
--- Mappings

f.map('n', '§', '<Cmd>Telescope buffers<CR>')
f.map('n', '<Tab>', find_files)


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
        ['q'] = actions.close,
        ['§'] = actions.close,
        ['p'] = layout_actions.toggle_preview,
        ['o'] = actions.select_default,
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
          ['d'] = actions.delete_buffer,
        },
      },
    },
  },
})

