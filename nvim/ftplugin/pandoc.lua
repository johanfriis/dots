------------------------------------------------------------------------------
--- Configure Pandoc --
---
--- These settings need to be set early in the startup
---

-- treat markdown and pandoc
vim.g['pandoc#filetypes#pandoc_markdown'] = 1

-- I would have liked to use 'hA' (hard, smart auto), but it does not treat my
-- log notes well. I would have to find a way to make pandoc understand that the
-- note: / meet: / work: bullets are just that, bullets
vim.g['pandoc#formatting#mode'] = 'hA' -- 'hA'
vim.g['pandoc#formatting#textwidth'] = 79

-- nice cursor movement on paragraphs
vim.g['pandoc#keyboard#wrap_cursor'] = 1

-- Disable folding by default and hide foldcolumn
vim.g['pandoc#folding#level'] = 10
vim.g['pandoc#folding#fdc'] = 0

-- I'm not ready for spelling just yet (not sure I ever will be)
vim.g['pandoc#spell#enabled'] = 0

-- Be less noisy
vim.g['pandoc#command#use_message_buffers'] = 0

-- I don't see myself using bibliographies anytime soon
vim.g['pandoc#modules#disabled'] = {
  'bibliographies'
}

