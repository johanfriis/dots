local f = require('utils.functions')
local uv = vim.uv

local M = {}

local plugins_dir = vim.fn.stdpath('config') .. '/lua/plugins/'

M.add = function(plugins)
  local _plugins = plugins
  if type(plugins) ~= 'table' then
    _plugins = { plugins }
  end

  for _, plugin in ipairs(_plugins) do
    vim.cmd(string.format([[%s %s]], 'packadd', plugin))
  end
end

local do_load = function(plugin, opts)
  M.add({ plugin })

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

M.load = function(plugin, opts, autocmds)

  if autocmds then
    local group_name = 'lazyload - ' .. plugin

    local callback = function()
      vim.api.nvim_del_augroup_by_name(group_name)
      do_load(plugin, opts)
    end

    local default_cmd = {
      events = 'VimEnter',
      pattern = '*',
      callback = callback,
    }

    if type(autocmds) == 'boolean' then
      f.autocmds(group_name, { default_cmd })
    elseif type(autocmds) == 'table' then
      for _, cmd in ipairs(autocmds) do
        cmd.callback = callback
      end
      f.autocmds(group_name, autocmds)
    end
  else
    do_load(plugin, opts)
  end

end

return M
