return {
  {
    "vim-pandoc/vim-pandoc",
    dependencies = {
      'vim-pandoc/vim-pandoc-syntax'
    },
    lazy = false,
    init = function()
      vim.g['pandoc#filetypes#pandoc_markdown'] = 1
      vim.g['pandoc#formatting#mode'] = 'hA'
      vim.g['pandoc#formatting#textwidth'] = 79
      vim.g['pandoc#keyboard#wrap_cursor'] = 1
      vim.g['pandoc#folding#level'] = 10
      vim.g['pandoc#folding#fdc'] = 0
      vim.g['pandoc#spell#enabled'] = 0
      vim.g['pandoc#command#use_message_buffers'] = 0

      vim.g['pandoc#modules#disabled'] = {
        'bibliographies'
      }

    end
  },
}
