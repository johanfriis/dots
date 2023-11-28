local f = require('utils.functions')
local p = require('utils.pack')
local tk = require('telekasten')

p.add({
  'telescope'
})

local notes = vim.fn.expand('~/dev/notes-tk')
local weeklies = notes .. '/log'

f.leader('n', 'nn', '<Cmd>Telekasten<CR>', 'Open Telekasten')

tk.setup({
  home = notes,
  command_palette_theme = 'dropdown',
  show_tags_theme = 'get_cursor',
  with_live_grep = true,
  weeklies = function()
    return weeklies .. '/' .. os.date('%Y')
  end,
  template_new_weekly = '.templates/weekly.md',
  calendar_opts = {
    weeknm = 1, --> WK01
  }
})


