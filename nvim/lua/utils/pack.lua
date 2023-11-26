local M = {}

M.load = function(plugin, opts)
  vim.cmd(string.format([[%s %s]], 'packadd', plugin))

  -- If opts are set, require the plugin and call setup with the
  -- opts. Otherwise, try to load a config file from plugins directory with same
  -- name as plugin.
  if opts then
    local ok, plug = pcall(require, plugin)
    if ok then plug.setup(opts) end
  else
    pcall(require, 'plugins.' .. plugin)
  end
end


return M
