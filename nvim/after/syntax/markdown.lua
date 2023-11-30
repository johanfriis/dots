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

-- Clear some unwanted syntax
vim.api.nvim_set_hl(0, '@text.reference.markdown_inline', {})
vim.api.nvim_set_hl(0, '@punctuation.special.markdown', {})
vim.api.nvim_set_hl(0, 'MarkdownError', {})
vim.api.nvim_set_hl(0, 'markdownListMarker', {})

-- WikiLink
vim.cmd [[syntax region MarkdownWikiLink matchgroup=MarkdownWikiLinkEnds start="\[\[" end="\]\]" transparent keepend concealends oneline display]]
vim.cmd [[syntax match  MarkdownWikiLinkName "\(\w\|[ -/#.]\)\+" contained containedin=MarkdownWikiLink]]
vim.cmd [[syntax match  MarkdownWikiLinkPipe "|" contained containedin=MarkdownWikiLink nextgroup=MarkdownWikiLinkName conceal]]
vim.cmd [[syntax match  MarkdownWikiLinkNamed "\_[^\]|]\+\ze|" contained containedin=MarkdownWikiLink nextgroup=MarkdownWikiLinkPipe conceal]]

hl('MarkdownWikiLinkEnds',      { fg = palette.subtle })
hl('MarkdownWikiLinkUnaliased', { fg = palette.rose })
hl('MarkdownWikiLinkNamed',     { fg = palette.subtle })
hl('MarkdownWikiLinkPipe',      { fg = palette.overlay })
hl('MarkdownWikiLinkName',      { fg = palette.text, italic = true, underdotted = true })

-- Highlight
vim.cmd [[syntax region MarkdownHighlight matchgroup=MarkdownHighlightEnds start="==" end="==" display oneline concealends]]

hl('MarkdownHighlightEnds', { fg = palette.subtle })
hl('MarkdownHighlight',     { fg = palette.love, standout = true })


----------------------------------------------------------------------
--- Common Markdown 

-- Headers
hl('@text.title.1.markdown',         { fg = palette.love, underdouble = true, bold = true  })
hl('@text.title.2.markdown',         { fg = palette.iris, underline = true })
hl('@text.title.3.markdown',         { fg = palette.iris })
hl('@text.title.4.markdown',         { fg = palette.iris })
hl('@text.title.5.markdown',         { fg = palette.iris })
hl('@text.title.6.markdown',         { fg = palette.iris })

hl('@text.title.1.marker.markdown',  { fg = palette.muted })
hl('@text.title.2.marker.markdown',  { fg = palette.muted })
hl('@text.title.3.marker.markdown',  { fg = palette.muted })
hl('@text.title.4.marker.markdown',  { fg = palette.muted })
hl('@text.title.5.marker.markdown',  { fg = palette.muted })
hl('@text.title.6.marker.markdown',  { fg = palette.muted })

hl('@text.emphasis.markdown_inline', { fg = palette.text })
hl('@text.strong.markdown_inline',   { fg = palette.text })

hl('@text.literal.block.markdown',   { bg = palette.surface })
hl('@text.literal.markdown_inline',  { bg = palette.surface })
hl('@text.quote.markdown',           { bg = palette.surface })

-- Conceal Header Markers
vim.cmd [[syntax match MarkdownHeaderMark "^#\{1,6}\s\ze\w.\+$" conceal]]

-- MarkdownTag #tag
vim.cmd [[syntax region MarkdownTag matchgroup=MarkdownTagMarker start="\(^\|\s\)\zs#\ze\<" end="\>" oneline]]
hl('MarkdownTagMarker', { fg = palette.muted })
hl('MarkdownTag', { fg = palette.rose })

-- Markdown List Marker

-- vim.cmd [[syntax match MarkdownListStart "\m^\s*\zs[*+-]\ze.*$" keepend conceal]]

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
--     I'm still going to leave this comment here for now, as it if very useful
-- Remove semantic highlight on markdown link
-- Thank you swarn! Gist on semantic highlighting
-- https://gist.github.com/swarn/fb37d9eefe1bc616c2a7e476c0bc0316
-- vim.api.nvim_set_hl(0, '@lsp.type.class.telekasten', {})
-- vim.api.nvim_set_hl(0, '@lsp.type.enumMember.telekasten', {})

--- }}}

-- vim: foldmethod=marker ts=2 sts=2 sw=2 et
