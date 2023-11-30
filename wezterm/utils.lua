local wez = require('wezterm')
local act = wez.action

local M = {}

M.map = function(keys_map)
  return function(key, mod, action)
    table.insert(keys_map, {
      key = key,
      mods = mod,
      action = action
    })
  end
end

M.RenameTab = act.PromptInputLine({
  description = 'Tab name:',
  action = wez.action_callback(function (window, _, line)
    if line then
      window:active_tab():set_title(line)
    end
  end)
})

M.RenameWorkspace = act.PromptInputLine({
  description = 'Workspace name:',
  action = wez.action_callback(function (_, _, line)
    if line then
      wez.mux.rename_workspace(
        wez.mux.get_active_workspace(),
        line
      )
    end
  end)
})

return M
