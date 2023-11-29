local palette = require('rose-pine.palette')
local hl      = require('utils.functions').hl

------------------------------------------------------------------------------
--- Pretty Markdown --

vim.cmd [[syntax region MarkdownWikiLink matchgroup=MarkdownWikiLinkEnds start="\[\[" end="\]\]" transparent keepend concealends oneline display]]
vim.cmd [[syntax match MarkdownWikiLinkName "\(\w\|[ -/#.]\)\+" contained containedin=MarkdownWikiLink]]
vim.cmd [[syntax match MarkdownWikiLinkPipe "|" contained containedin=MarkdownWikiLink nextgroup=MarkdownWikiLinkName conceal]]
vim.cmd [[syntax match MarkdownWikiLinkNamed "\_[^\]|]\+\ze|" contained containedin=MarkdownWikiLink nextgroup=MarkdownWikiLinkPipe conceal]]

hl('MarkdownWikiLinkEnds', { fg = palette.subtle })
hl('MarkdownWikiLinkUnaliased', { fg = palette.rose })
hl('MarkdownWikiLinkNamed', { fg = palette.subtle })
hl('MarkdownWikiLinkPipe', { fg = palette.overlay })
hl('MarkdownWikiLinkName', { fg = palette.iris, italic = true })

hl('tkTag', { fg = palette.foam })
--syntax region tkHighlight matchgroup=tkBrackets start=/==/ end=/==/ display oneline contains=tkAliasedLink

hl('markdownH1', { fg = palette.love })
hl('markdownH2', { fg = palette.iris })

-- XXX This is actually fixed by turning off semantic tokens on the lsp
--     I'm still going to leavr this comment here for now, as it if very useful
-- Remove semantic highlight on markdown link
-- Thank you swarn! Gist on semantic highlighting
-- https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
vim.api.nvim_set_hl(0, '@lsp.type.class.telekasten', {})
vim.api.nvim_set_hl(0, '@lsp.type.enumMember.telekasten', {})


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

