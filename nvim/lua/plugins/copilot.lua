local cmp = require('cmp')
local copilot = require('copilot')

copilot.setup({
  suggestion = { enabled = true },
  panel = { enabled = true },
})

-- hide suggestions when cmp triggers
cmp.event:on("menu_opened", function()
  vim.b.copilot_suggestion_hidden = true
end)

cmp.event:on("menu_closed", function()
  vim.b.copilot_suggestion_hidden = false
end)

-- local client = require('copilot.client')
-- print('is disabled? ' .. string.format("%s", client.is_disabled()))

-- TODO make a toggle for turning off copilot
---- local suggestion = require('copilot.suggestion')
---- suggestions.toggle_auto_trigger()
-- TODO also make something visible in the statusbar, using:
---- suggestions.is_visible()


