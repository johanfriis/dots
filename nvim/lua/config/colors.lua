local load = require('utils.pack').load

-- Colors -----------------------------------------------------------------
-- render lots of colors

vim.opt.termguicolors = true
vim.opt.background    = 'dark'

load "rose-pine"
vim.cmd.colorscheme     'rose-pine-moon' -- 'quiet'

---- vim: foldmethod=marker ts=2 sts=2 sw=2 et
