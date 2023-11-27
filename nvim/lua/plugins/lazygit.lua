local f = require('utils.functions')
local palette = require('rose-pine.palette')

require('lazygit')

f.hl('LazyGitFloat', { bg = palette.surface })
f.hl('LazyGitBorder', { fg = palette.iris, bg = palette.surface })

f.leader('n', 'gg', '<Cmd>LazyGit<CR>', 'Open LazyGit')

vim.cmd [[LazyGit]]