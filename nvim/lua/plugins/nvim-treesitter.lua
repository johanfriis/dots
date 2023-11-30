-- local p = require('utils.pack')

local treesitter = require('nvim-treesitter.configs')

local langs = {
  'lua',
  'markdown',
  'markdown_inline',
}

local config = {
  ensure_installed = langs,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { 'markdown' },
  },


  indent = {
    enable = true,
  }
}

treesitter.setup(config)

local offset_first_n = function(match, _, _, pred, metadata)
  ---@cast pred integer[]
  local capture_id = pred[2]
  if not metadata[capture_id] then
    metadata[capture_id] = {}
  end

  local range = metadata[capture_id].range
  or { match[capture_id]:range() }
  local offset = pred[3] or 0

  range[4] = range[2] + offset
  metadata[capture_id].range = range
end

vim.treesitter.query.add_directive(
'offset-first-n!',
offset_first_n,
true
)

---- vim: foldmethod=marker ts=2 sts=2 sw=2 et
