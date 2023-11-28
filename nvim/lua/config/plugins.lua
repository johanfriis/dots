local p = require('utils.pack')

p.load('mini.align', {})
p.load('mini.comment', {})
p.lazy('mini.move', {})
p.lazy('mini.pairs', {})

p.lazy('telescope')
p.lazy('telekasten')

p.lazy('copilot', nil, { 'InsertEnter' })
p.load('cmp')
p.load('lspconfig')

p.lazy('mini-clue')

vim.api.nvim_create_user_command('LazyGit', function()
  vim.api.nvim_del_user_command('LazyGit')
  p.load('lazygit')
end, {})
