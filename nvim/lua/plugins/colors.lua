vim.opt.background    = 'dark'
vim.opt.termguicolors = true

-- See here for options:
-- https://github.com/rose-pine/neovim?tab=readme-ov-file#options

return {
    {
        'rose-pine/neovim',
        opts = {
            dark_variant = 'moon',
            disable_background = true,
            highlight_groups = {
                NormalFloat = { bg = 'base', },
                FloatBorder = { fg = 'iris', bg = 'base', },
                FloatTitle =  { fg = 'iris', bg = 'base', },
                FloatFooter = { fg = 'iris', bg = 'base', },

                LazyGitFloat = { bg = 'surface' },
                LazyGitBorder = { fg = 'iris', bg = 'surface' },

                TelescopeNormal = { fg = 'subtle', bg = 'base' },
                TelescopeBorder = { fg = 'iris',   bg = 'base' },
                TelescopePromptBorder = { fg = 'iris',   bg = 'base' },
                TelescopeResultsBorder = { fg = 'iris',   bg = 'base' },
                TelescopePreviewBorder = { fg = 'iris',   bg = 'base' },

                TelescopeSelection = { fg = 'love',   bg = 'highlight_low' },
                TelescopeSelectionCaret = { fg = 'love' },
                TelescopeMultiSelection = { fg = 'pine' },

                TelescopeMatching = { fg = 'love',   bg = 'highlight_low' },
                TelescopePromptPrefix = { fg = 'love',   bg = 'highlight_low' },
                TelescopePromptNormal = { bg = 'base' },

                Pmenu = { bg = 'base' },
                PmenuSel = { fg = 'love', bg = 'highlight_low' },
                PmenuBorder = { fg = 'iris', bg = 'base' },

                CmpItemAbbrMatch = { fg = 'gold', bold = true },
                CmpItemAbbrMatchFuzzy = { fg = 'rose', bold = true },
                CmpItemMenu = { fg = 'iris', italic = true },
                CmpItemAbbrDeprecated = { fg = '#7E8294', strikethrough = true },

                MiniJump2dSpot = { fg = 'iris', bg = 'base' },
                MiniJump2dSpotUnique = { fg = 'love', bg = 'base' },
            },
        },
        name = 'rose-pine',
        priority = 1000,
        config = function(_, opts)
            require('rose-pine').setup(opts)
            vim.cmd [[colorscheme rose-pine]]
        end,
    },
}
