local f = require('utils.functions')
local p = require('utils.pack')
local palette = require('rose-pine.palette')
local bufmap = f.bufmap

------------------------------------------------------------------------------
--- Config

local servers = {
  'lua_ls',
}

local attach = function() --client, bufnr

  p.add('trouble')
  local trouble = require('trouble')

  bufmap('n', 'K',  vim.lsp.buf.hover)
  bufmap('n', 'gd', vim.lsp.buf.definition)
  bufmap('n', 'gD', vim.lsp.buf.declaration)
  bufmap('n', 'gi', vim.lsp.buf.implementation)
  bufmap('n', 'gt', vim.lsp.buf.type_definition)
  bufmap('n', 'gr', vim.lsp.buf.references)
  bufmap('n', 'gs', vim.lsp.buf.signature_help)
  bufmap('n', 'gn', vim.lsp.buf.rename)
  bufmap('n', 'gf', vim.lsp.buf.format)
  bufmap('n', 'gl', vim.diagnostic.open_float)
  bufmap('n', '[d', vim.diagnostic.goto_prev)
  bufmap('n', ']d', vim.diagnostic.goto_next)
  bufmap('n', 'ge', trouble.open)

  bufmap({ 'n', 'v' }, 'gl', vim.lsp.buf.code_action)

end

-- highlight! link FloatBorder Normal highlight! link NormalFloat Normal
f.hl('FloatBorder', { fg = palette.iris, bg = palette.surface })
f.hl('NormalFloat', { bg = palette.surface })


------------------------------------------------------------------------------
--- Setup

p.add({
  'mason',
  'mason-lspconfig',
  'neodev',
  'cmp-lsp',
})

local lspconfig       = require('lspconfig')
local mason           = require('mason')
local mason_lspconfig = require('mason-lspconfig')
local neodev          = require('neodev')
local cmp_lsp         = require('cmp_nvim_lsp')

mason.setup()
mason_lspconfig.setup({
  ensure_installed = servers
})
neodev.setup()

local defaults = lspconfig.util.default_config

defaults.capabilities = vim.tbl_deep_extend(
  'force',
  defaults.capabilities,
  cmp_lsp.default_capabilities()
)

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' }),
}

mason_lspconfig.setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = attach,
      capabilities = defaults.capabilities,
      handlers = handlers
    })
  end,
})
