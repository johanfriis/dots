local M = {}

M.map = function(key, mod, action)
  return {
    key = key,
    mod = mod,
    action = action
  }
end

return M
