local opts = {
  options = {
    disabled_filetypes = {
      "netrw",
    },
  },
  sections = {
    lualine_x = { "filetype" },
  },
}

return {
  "nvim-lualine/lualine.nvim",
  event = { "VimEnter" },
  opts = opts,
}
