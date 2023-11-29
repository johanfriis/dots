local hl = require('utils.functions').hl
local load = require('utils.pack').load

-- Colors -----------------------------------------------------------------
-- render lots of colors

vim.opt.termguicolors = true
vim.opt.background    = 'dark'

load "rose-pine"
vim.cmd.colorscheme     'rose-pine-moon' -- 'quiet'


local palette = require('rose-pine.palette')

hl('NormalFloat', { bg = palette.base })
hl('FloatBorder', { fg = palette.iris, bg = palette.base })
hl('FloatTitle',  { fg = palette.iris, bg = palette.base })
hl('FloatFooter', { fg = palette.iris, bg = palette.base })
