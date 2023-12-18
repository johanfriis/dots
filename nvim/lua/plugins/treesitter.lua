-- https://github.com/nvim-treesitter/nvim-treesitter

local langs = {
  'lua',
  'vimdoc',
  'markdown',
  'markdown_inline',
}

local config = {
  ensure_installed = langs,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = { 'markdown' },
  },


  indent = {
    enable = true,
  },

  textobjects = {
      select = {
          enable = true,
          keymaps = {
              ['af'] = {
                  query = '@function.outer',
                  desc = 'select function [outer]',
              },
              ['if'] = {
                  query = '@function.inner',
                  desc = 'select function [inner]',
              },
          },
      }
  }
}

return {
  {
      'nvim-treesitter/nvim-treesitter',
      lazy = true,
      event = { 'BufNew', 'BufReadPre', 'InsertEnter' },
      dependencies = {
          { 'nvim-treesitter/nvim-treesitter-textobjects' },
      },
      build = ':TSUpdate',
      opts = config,
  },
}

---- vim: foldmethod=marker
