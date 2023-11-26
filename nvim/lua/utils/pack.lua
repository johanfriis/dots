local M = {}

M.load = function(plugin)
  vim.cmd(string.format([[%s %s]], 'packadd', plugin))

  -- Try to load plugins config. It must have the
  -- same name as the plugin directory.
  pcall(require, 'plugins.' .. plugin)
end


return M
