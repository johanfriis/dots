---@diagnostic disable: missing-fields
-- https://github.com/hrsh7th/nvim-cmp
-- https://github.com/dcampos/nvim-snippy

local sources = {
    { name = 'nvim_lsp', group_index = 1 },
    -- { name = 'copilot' },
    { name = 'snippy', group_index = 2 },
    { name = 'buffer', group_index = 3 },
    { name = 'path', group_index = 3 },
}

local window_style = {
    border = 'single',
    -- border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,FloatBorder:PmenuBorder,Search:None",
    side_padding = 1,
}

return {
    {
        'hrsh7th/nvim-cmp',
        lazy = true,
        event = { 'InsertEnter' },
        dependencies = {
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            -- 'hrsh7th/cmp-cmdline',
            --  'cmp-lsp',

            'dcampos/nvim-snippy',
            'dcampos/cmp-snippy',

            'onsails/lspkind.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            local cmp = require('cmp')
            local snippy = require('snippy')
            local lspkind = require('lspkind')

            cmp.setup({
                sources = sources,

                preselect = cmp.PreselectMode.Item,

                completion = {
                    keyword_length = 3,
                    autocomplete = false,
                },

                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    -- use C-n to trigger completion too
                    ['<C-n>'] = function(_)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            cmp.complete()
                            cmp.select_next_item()
                        end
                    end,
                }),

                snippet = {
                    expand = function(args)
                        snippy.expand_snippet(args.body)
                    end,
                },

                window = {
                    completion = {
                        border = window_style.border,
                        winhighlight = window_style.winhighlight,
                        side_padding = window_style.side_padding,
                        col_offset = -3,
                        scrollbar = false,
                    },
                    documentation = window_style,
                },

                experimental = {
                    ghost_text = false,
                },

                formatting = {
                    expandable_indicator = true,
                    fields = { "kind", "abbr", "menu" },
                    format = lspkind.cmp_format({
                        mode = 'symbol',
                    }),
                },
            })


        end,
    },
}

---- vim: foldmethod=marker
