local f = require('utils.functions')
local tree = require('nvim-tree')
local api = require("nvim-tree.api")

local map = f.map

local on_attach = function(bufnr)

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
  map('n', 'P', api.tree.change_root_to_parent, opts('Parent'))
  map('n', '?', api.tree.toggle_help,           opts('Help'))

  map("n", "l", api.node.open.edit,             opts("Open"))
  map("n", "L", api.node.open.preview,          opts("Preview"))
  map("n", "H", api.tree.collapse_all,          opts("Collapse All"))

end

tree.setup({
  on_attach = on_attach,
  hijack_cursor = true,
  select_prompts = true, -- testing this one out
  view = {
    centralize_selection = true,
    cursorline = true,
    -- signcolumn = 'no',

  },
  renderer = {
    -- group_empty = true
    highlight_git = false,
    highlight_diagnostics = false,
    highlight_modified = 'none',
    indent_markers = {
      enable = true,
    },
    icons = {
      git_placement = 'after',
      diagnostics_placement = 'after',
      modified_placement = 'after',
      show = {
        file = false,
        folder = false,
        git = false,
        modified = false,
        diagnostics = false,
        bookmarks = false,
      },
    },
  },
  update_focused_file = {
    enable = true,
  },
  git = {
    enable = false
  },
  diagnostics = {
    enable = false,
  },
  modified = {
    enable = false,
  },
  ui = {
    confirm = {
      default_yes = true,
    }
  }
})
