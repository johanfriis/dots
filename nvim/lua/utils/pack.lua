local put = require('utils.functions').put
local autocmd = require('utils.functions').autocmd
local uv = vim.uv

local M = {}

local plugins_dir = vim.fn.stdpath('config') .. '/lua/plugins/'

M.load = function(plugin, opts)
  vim.cmd(string.format([[%s %s]], 'packadd', plugin))

  -- If opts are set, require the plugin and call setup with the
  -- opts. Otherwise, try to load a config file from plugins directory with same
  -- name as plugin.
  if opts then
    if type(opts) == 'function' then
      opts()
    else
      local plug = require(plugin)
      plug.setup(opts)
    end

  else
    local path = plugins_dir .. plugin .. '.lua'
    local stat = uv.fs_stat(path)
    if stat then
      require('plugins.' .. plugin)
    end
  end
end

M.lazy = function(plugin, opts, events)
  local ev = events or { 'VimEnter' }
  autocmd("LazyLoad " .. plugin, {
    {
      events = ev,
      pattern = '*',
      callback = function()
        M.load(plugin, opts)
      end
    }
  })
end


return M
