local PKGS = {
    { 'savq/paq-nvim', pin = true, opt = true },

    'rose-pine/neovim',

    -- Tree-sitter
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    -- 'nvim-treesitter/nvim-treesitter-textobjects',

    -- MINI
    { 'echasnovski/mini.bracketed', opt = true },
    { 'echasnovski/mini.clue', opt = true },
    { 'echasnovski/mini.comment', opt = true },
    { 'echasnovski/mini.extra', opt = true },
    { 'echasnovski/mini.files', opt = true },
    { 'echasnovski/mini.hipatterns', opt = true },
    { 'echasnovski/mini.jump', opt = true },
    { 'echasnovski/mini.jump2d', opt = true },
    { 'echasnovski/mini.misc', opt = true },
    { 'echasnovski/mini.move', opt = true },
    { 'echasnovski/mini.pairs', opt = true },
    { 'echasnovski/mini.pick', opt = true },
    { 'echasnovski/mini.sessions', opt = true },
    { 'echasnovski/mini.starter', opt = true },
    { 'echasnovski/mini.surround', opt = true },
    { 'echasnovski/mini.tabline', opt = true },
    { 'echasnovski/mini.trailspace', opt = true },

    { 'andymass/vim-matchup', opt = true },

    { 'mickael-menu/zk-nvim', opt = true },

    -- { 'ixru/nvim-markdown', opt = true },


    { 'aserowy/tmux.nvim', opt = true },



    --    -- Completion, LSP & Language plugins
    --    'echasnovski/mini.completion',
    --    'neovim/nvim-lspconfig',
    --    'rust-lang/rust.vim',
    --    'JuliaEditorSupport/julia-vim',
    --
    --    -- Markup
    --    'lervag/VimTeX',
    --    'lervag/wiki.vim',
    --    'rhysd/vim-gfm-syntax',
    --    { 'mattn/emmet-vim', opt = true },
    --
    --    -- Git
    --    'lewis6991/gitsigns.nvim',
    --    'tpope/vim-fugitive',
    --
    --    -- Misc
    --    'tpope/vim-commentary',
    --    'tpope/vim-surround',
    --    { 'norcalli/nvim-colorizer.lua', as = 'colorizer', opt = true },
    --    { 'junegunn/vim-easy-align', as = 'easy-align', opt = true },
    --    { 'mechatroner/rainbow_csv', opt = true },
}

-- ----------------------------------------------------------------------------
-- {{{ Manage Packages -------------------------------------------------

function clone_paq()
    local path = vim.fn.stdpath 'data' .. '/site/pack/paqs/opt/paq-nvim'
    if vim.fn.empty(vim.fn.glob(path)) > 0 then
        vim.fn.system {
            'git',
            'clone',
            '--depth=1',
            'https://github.com/savq/paq-nvim.git',
            path,
        }
    end
end

--local function paq()
--    vim.cmd [[packadd paq-nvim]]
--    return require('paq'):setup({
--        path = vim.fn.stdpath 'state' .. 'site/pack/paqs'
--    })(PKGS)
--end

function bootstrap()
    clone_paq()

    -- Load Paq
    vim.cmd 'packadd paq-nvim'
    local paq = require 'paq'

    -- Exit nvim after installing plugins
    vim.cmd 'autocmd User PaqDoneInstall quit'

    -- Read and install packages
    paq(PKGS):install()
end

function sync_all()
    --paq():sync()
    require 'paq'(PKGS):sync()
end

-- }}}

return { bootstrap = bootstrap, sync_all = sync_all }

-- vim: fdm=marker sw=4 ts=4 sts=4 et
