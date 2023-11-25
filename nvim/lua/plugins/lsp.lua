local zero_init = function()
  vim.g.lsp_zero_extend_cmp = 0
  vim.g.lsp_zero_extend_lspconfig = 0
end

local lsp_config = function()
  require('neodev').setup({})

  local zero = require 'lsp-zero'
  zero.extend_lspconfig()

  zero.on_attach(function(client, bufnr)
    zero.default_keymaps({ buffer = bufnr })
  end)

  zero.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
  })

  vim.diagnostic.config({
    virtual_text = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
  })

  require('mason').setup()
  require('mason-lspconfig').setup({
    handlers = {
      zero.default_setup,
      lua_ls = function()
        local lua_opts = zero.nvim_lua_ls()
        require('lspconfig').lua_ls.setup(lua_opts)
      end
    }
  })
end

local cmp_config = function()
  local zero = require 'lsp-zero'
  zero.extend_cmp()

  local cmp = require('cmp')
  local cmp_action = zero.cmp_action()

  cmp.setup({
    mapping = cmp.mapping.preset.insert({
      ['<tab>'] = cmp_action.luasnip_supertab(),
      ['<S-tab>'] = cmp_action.luasnip_shift_supertab(),

      ['<cr>'] = cmp.mapping.confirm({ select = false }),
      ['<C-space>'] = cmp.mapping.complete(),

      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),

    }),
    formatting = {
      fields = { 'abbr', 'kind', 'menu' },
      format = require('lspkind').cmp_format({
        mode = 'symbol',
        maxwidth = 20,
        ellipsis_char = '...'
      })

    },
  })
end

-- "hrsh7th/cmp-nvim-lsp",
-- "hrsh7th/cmp-nvim-lua",
-- "hrsh7th/cmp-buffer",
-- "hrsh7th/cmp-path",
-- "hrsh7th/cmp-cmdline",
-- "hrsh7th/cmp-emoji",
-- "hrsh7th/cmp-nvim-lsp-signature-help",
-- zbirenbaum/copilot-cmp




return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = zero_init,
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
  },
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { "folke/neodev.nvim" },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'williamboman/mason-lspconfig.nvim' },
    },
    config = lsp_config
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'L3MON4D3/LuaSnip' },
      { 'onsails/lspkind-nvim' },
    },
    config = cmp_config
  },

}
