local palette = require('rose-pine.palette')
local hl      = require('utils.functions').hl

------------------------------------------------------------------------------
--- Custom "Log" language --

-- A nice little mini language for logging
-- Inspired by the following article:
-- https://peppe.rs/posts/plain_text_journaling/
vim.cmd [[ab note: ☰]]
vim.cmd [[ab meet: ◉]]
vim.cmd [[ab work: ≻]]


vim.cmd [[syn region MarkdownLogEntry start="^[☰≻◉]\s" end="$" contains=MarkdownLogTime,MarkdownLogContent]]
vim.cmd [[syn match MarkdownLogTime /\s:\d\{4}:\s/]]
vim.cmd [[syn match MarkdownLogNote /^☰/]]
vim.cmd [[syn match MarkdownLogMeet /^≻/]]
vim.cmd [[syn match MarkdownLogWork /^◉/]]

hl('MarkdownLogNote', { fg = palette.iris })
hl('MarkdownLogMeet', { fg = palette.gold })
hl('MarkdownLogWork', { fg = palette.love })
hl('MarkdownLogTime', { fg = palette.highlight_high })
