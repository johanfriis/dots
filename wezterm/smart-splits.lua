local wez = require('wezterm')

local M = {}

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == 'true'
end

-- -- if you *ARE* lazy-loading smart-splits.nvim (not recommended)
-- -- you have to use this instead, but note that this will not work
-- -- in all cases (e.g. over an SSH connection). Also note that
-- -- `pane:get_foreground_process_name()` can have high and highly variable
-- -- latency, so the other implementation of `is_vim()` will be more
-- -- performant as well.
-- local function is_vim(pane)
--   -- This gsub is equivalent to POSIX basename(3)
--   -- Given "/foo/bar" returns "bar"
--   -- Given "c:\\foo\\bar" returns "bar"
--   local process_name = string.gsub(pane:get_foreground_process_name(), '(.*[/\\])(.*)', '%2')
--   return process_name == 'nvim' or process_name == 'vim'
-- end

M.split_nav = function(keys, resize_or_move, key, direction)
  table.insert(keys, {
    key = key,
    mods = resize_or_move == 'resize' and 'META' or 'CTRL',
    action = wez.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == 'resize' and 'META' or 'CTRL' },
        }, pane)
      else
        if resize_or_move == 'resize' then
          win:perform_action({ AdjustPaneSize = { direction, 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction }, pane)
        end
      end
    end),
  })
end

return M
