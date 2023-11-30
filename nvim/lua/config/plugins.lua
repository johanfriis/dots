local p = require('utils.pack')

-- only load startuptime if we are actually debugging it
if vim.iter(vim.v.argv):any(function(pred) return pred == "--startuptime" end) then
  p.load('vim-startuptime')
end

p.load('smart-splits')
p.load('mini.align', {}, true)
p.load('mini.comment', {}, true)
p.load('mini.pairs', {}, true)
p.load('mini-clue', nil, true)

p.load('telescope', nil, {
  { events = 'FileType', pattern = 'telekasten' },
  { events = { 'BufEnter', 'BufNewFile' }}
})
p.load('telekasten', nil, {
  { events = 'FileType', pattern = 'telekasten' },
  -- { events = { 'BufEnter', 'BufNewFile' }}
})

-- BufWinEnter
p.load('copilot', nil, {{ events = 'InsertEnter' }})
p.load('cmp')
p.load('lspconfig') --, nil, {{ events = { 'BufEnter', 'BufNewFile' }}})

vim.api.nvim_create_user_command('Telekasten', function(event)
  vim.api.nvim_del_user_command('Telekasten')
  p.load('telekasten')

  local command = {
    cmd = 'Telekasten',
    args = { event.args },
  }
  vim.cmd(command)
end, {
  nargs = '*',
  complete = function(_, line)
    p.load('telekasten')
    return vim.fn.getcompletion(line, 'cmdline')
  end
})

vim.api.nvim_create_user_command('LazyGit', function()
  vim.api.nvim_del_user_command('LazyGit')
  p.load('lazygit')
end, {})
