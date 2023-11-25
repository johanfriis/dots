-- Supported Languages
-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages

local langs = {
  "lua",
  "bash",
  "markdown",
  "markdown_inline",
}

local opts = {
  ensure_installed = langs,
  highlight = {
    enable = true,
  },
  matchup = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}

-- {{{ Add custom markdown parsers that support tags and wikilinks
-- See: https://github.com/MDeiml/tree-sitter-markdown/issues/54#issuecomment-1646561140
local parsers = {}

parsers.markdown = {
  install_info = {
    url = "/Users/dkJohFri/dev/tools/tree-sitter-markdown/tree-sitter-markdown",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "markdown",
}

parsers.markdown_inline = {
  install_info = {
    url = "/Users/dkJohFri/dev/tools/tree-sitter-markdown/tree-sitter-markdown-inline",
    files = { "src/parser.c", "src/scanner.c" },
  },
  filetype = "markdown",
}
-- }}}

local config = function()
  local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
  parser_configs.markdown = parsers.markdown
  parser_configs.markdown_inline = parsers.markdown_inline


  require("nvim-treesitter.configs").setup(opts)
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = config,
  },
}

-- vim: foldmethod=marker ts=2 sts=2 sw=2 et
