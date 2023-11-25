local config = function()
  local MiniPick = require("mini.pick")
  MiniPick.setup({})
  vim.ui.select = MiniPick.ui_select
end

-- local items = vim.schedule_wrap(function()
--   print("I am actually starting")
--   return require("mini.pick").set_picker_items_from_cli({})
-- end)
local cmd = function()
  -- require("mini.pick").start({ source = { items = items, name = "Todo" } })
  require("mini.pick").builtin.cli({
    command = { "cat", "/Users/dkJohFri/dev/notes/todo.txt" },
    postprocess = function(items)
      puput(items)
      return items
    end
  })
end

local keys = {
  { ",",          [[<Cmd>Pick buf_lines scope='current'<CR>]], nowait = true },
  { "<leader>ft", cmd,                                         desc = "Find todo" },
}

_G.rose_pine_highlight_groups["MiniPickMatchCurrent"] = { fg = "rose", bg = "base" }

return {
  {
    "echasnovski/mini.pick",
    event = { "BufReadPre", "BufNewFile" },
    config = config,
    keys = keys,
  },
}

-- vim: foldmethod=marker
