local p = require('utils.pack')

p.load('mini.align', {})
p.load('mini.comment', {})
p.lazy('mini.move', {})
p.lazy('mini.pairs', {})
p.load('cmp')

p.lazy('copilot', nil, { 'InsertEnter' })
p.load('lspconfig')

p.load('mini-clue')

vim.api.nvim_create_user_command('LazyGit', function()
  vim.api.nvim_del_user_command('LazyGit')
  p.load('lazygit')
end, {})
