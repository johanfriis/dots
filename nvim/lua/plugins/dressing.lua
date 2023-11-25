local opts = {}

return {
  {
    'stevearc/dressing.nvim',
    event = 'BufReadPre',
    enabled = true,
    opts = opts,
  }
}
