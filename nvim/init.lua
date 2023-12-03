vim.loader.enable()

local g = vim.g

-- Disable unused built-in plugins.
g.loaded_gzip         = true
g.loaded_rplugin      = true
g.loaded_tarPlugin    = true
g.loaded_tohtml       = true
g.loaded_tutor        = true
g.loaded_zipPlugin    = true
g.loaded_editorconfig = true
g.loaded_man          = true
g.loaded_netrw        = true
g.loaded_netrwPlugin  = true

require('config')

---- vim: foldmethod=marker ts=2 sts=2 sw=2 et
