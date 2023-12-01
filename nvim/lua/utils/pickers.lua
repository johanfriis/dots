local M = {}

M.adjacent = function()
  local builtin = require('telescope.builtin')
  local themes = require('telescope.themes')
  local utils = require('telescope.utils')

  local current = utils.buffer_dir()
  builtin.find_files(themes.get_dropdown({
    prompt_title = 'Adjacent',
    cwd = current,
    previewer = false,
  }))
end

return M

---- vim: foldmethod=marker ts=2 sts=2 sw=2 et
