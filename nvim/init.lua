-- {{{ Install package manager
--     https://github.com/folke/lazy.nvim
--     `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

_G.rose_pine_highlight_groups = {}

-- require config
require 'functions'
require 'options'
require 'mappings'

-- setup lazy plugins
require('lazy').setup('plugins', {
  defaults = {
    lazy = true,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'rrhelper',
        'tarPlugin',
        'zipPlugin',
        -- 'netrwPlugin',
        -- 'netrwFileHandlers',
        '2html_plugin',
        'vimballPlugin',
        'getscriptPlugin',
        'logipat',
        'tutor',
        'matchit',
        'matchparen',
        'man', 
        'rplugin',
        'tohtml',
        'spellfile',
        'health',
      }
    }
  },
  lockfile = vim.fn.stdpath('data') .. '/lazy-lock.json',
})

---- vim: foldmethod=marker ts=2 sts=2 sw=2 et
