return {
  --     https://github.com/aserowy/tmux.nvim
  {
    "aserowy/tmux.nvim",
    event = { "VimEnter" },
    opts = {
      resize = {
        enable_default_keybindings = false,
      },
    },
  },
}

-- vim: foldmethod=marker ts=2 sts=2 sw=2 et
