require('config.options')
require('config.autocmds')
require('config.mappings')

-- {{{ Install Lazy
--     https://github.com/folke/lazy.nvim
--     `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
-- }}}

require('lazy').setup('plugins', {
    defaults = {
        lazy = false,
    },
    change_detection = {
        enabled = true,
        notify = false,
    },
    ui = {
        border = 'single',
    },
    performance = {
        rtp = {
            disabled_plugins = {
                'editorconfig',
                'gzip',
                'man',
                'matchit',
                'matchparen',
                -- 'netrwPlugin',
                -- 'osc52',
                'rplugin',
                -- 'shada',
                'spellfile',
                'tarPlugin',
                'tohtml',
                'tutor',
                'zipPlugin',
            }
        }
    },
    lockfile = vim.fn.stdpath('data') .. '/lazy-lock.json',
})

---- vim: foldmethod=marker
