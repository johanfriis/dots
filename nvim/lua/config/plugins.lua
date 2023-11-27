local p = require('utils.pack')

p.load('mini.align', {})
p.load('mini.comment', {})
p.lazy('mini.move', {})
p.lazy('mini.pairs', {})
p.load('cmp')

p.lazy('copilot', nil, { 'InsertEnter' })
p.load('lspconfig')
