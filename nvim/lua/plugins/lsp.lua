local servers = {
    'lua_ls'
}

local attach = function(client)
    local bufmap = require('utils.functions').bufmap

    -- turn off unwanted tokens in marksman
    if client.name == 'marksman' then
        client.server_capabilities.semanticTokensProvider = nil
    end

    bufmap('n', 'K',  vim.lsp.buf.hover)
    bufmap('n', '[d', vim.diagnostic.goto_prev)
    bufmap('n', ']d', vim.diagnostic.goto_next)

end

return {
    {
        'neovim/nvim-lspconfig',
        lazy = true,
        cmd = { 'LspInfo', 'LspInstall', 'LspStart', },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            'folke/neodev.nvim',
            'hrsh7th/cmp-nvim-lsp',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
        config = function()
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
        end,
    },
}

---- vim: foldmethod=marker
