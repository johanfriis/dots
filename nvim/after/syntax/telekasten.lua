local palette = require('rose-pine.palette')
local hl      = require('utils.functions').hl

------------------------------------------------------------------------------
--- {{{ Notes

-- If I ever want to implement treesitter markdown extensions, here is a good
-- starting point that I found:
-- https://www.reddit.com/r/neovim/comments/vr9m43/comment/iewhk7x
-- https://github.com/lukas-reineke/headlines.nvim

-- }}}

------------------------------------------------------------------------------
--- Pretty Markdown --

-- WikiLink
vim.cmd [[syntax region MarkdownWikiLink matchgroup=MarkdownWikiLinkEnds start="\[\[" end="\]\]" transparent keepend concealends oneline display]]
vim.cmd [[syntax match  MarkdownWikiLinkName "\(\w\|[ -/#.]\)\+" contained containedin=MarkdownWikiLink]]
vim.cmd [[syntax match  MarkdownWikiLinkPipe "|" contained containedin=MarkdownWikiLink nextgroup=MarkdownWikiLinkName conceal]]
vim.cmd [[syntax match  MarkdownWikiLinkNamed "\_[^\]|]\+\ze|" contained containedin=MarkdownWikiLink nextgroup=MarkdownWikiLinkPipe conceal]]

hl('MarkdownWikiLinkEnds',      { fg = palette.subtle })
hl('MarkdownWikiLinkUnaliased', { fg = palette.rose })
hl('MarkdownWikiLinkNamed',     { fg = palette.subtle })
hl('MarkdownWikiLinkPipe',      { fg = palette.overlay })
hl('MarkdownWikiLinkName',      { fg = palette.iris, italic = true, underdotted = true })

-- Highlight
vim.cmd [[syntax region MarkdownHighlight matchgroup=MarkdownHighlightEnds start="==" end="==" display oneline concealends]]

hl('MarkdownHighlightEnds', { fg = palette.subtle })
hl('MarkdownHighlight',     { fg = palette.love, standout = true })


-- Common Markdown 
hl('markdownH1', { fg = palette.love, underdouble = true, bold = true  })
hl('markdownH2', { fg = palette.iris })

hl('markdownCode', { fg = palette.subtle, bg = palette.surface })
hl('markdownCodeBlock', { fg = palette.subtle, bg = palette.surface })
hl('markdownCodeDelimiter', { fg = palette.subtle, bg = palette.surface })


-- Telekasten specials
hl('tkTag', { fg = palette.foam })






------------------------------------------------------------------------------
--- Custom "Log" language --

-- A nice little mini language for logging
-- Inspired by the following article:
-- https://peppe.rs/posts/plain_text_journaling/
vim.cmd [[ab note: ☰]]
vim.cmd [[ab meet: ◉]]
vim.cmd [[ab work: ≻]]

vim.cmd [[syn region MarkdownLogEntry start="^[☰≻◉]\s" end="$" contains=MarkdownLogTime,MarkdownLogContent]]
vim.cmd [[syn match  MarkdownLogTime /\s:\d\{4}:\s/]]
vim.cmd [[syn match  MarkdownLogNote /^☰/]]
vim.cmd [[syn match  MarkdownLogMeet /^≻/]]
vim.cmd [[syn match  MarkdownLogWork /^◉/]]

hl('MarkdownLogNote', { fg = palette.iris })
hl('MarkdownLogMeet', { fg = palette.gold })
hl('MarkdownLogWork', { fg = palette.love })
hl('MarkdownLogTime', { fg = palette.highlight_high })


------------------------------------------------------------------------------
--- {{{ Legacy --

-- XXX This is actually fixed by turning off semantic tokens on the lsp
--     I'm still going to leavr this comment here for now, as it if very useful
-- Remove semantic highlight on markdown link
-- Thank you swarn! Gist on semantic highlighting
-- https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
-- vim.api.nvim_set_hl(0, '@lsp.type.class.telekasten', {})
-- vim.api.nvim_set_hl(0, '@lsp.type.enumMember.telekasten', {})

--- }}}

-- vim: foldmethod=marker ts=2 sts=2 sw=2 et
