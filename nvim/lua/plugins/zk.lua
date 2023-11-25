return {
  -- {{{ zk-nvim
  {
    "mickael-menu/zk-nvim",
    cmd = {
      "ZkNew",
      "ZkNotes",
      "ZkIndex",
      "ZkNewFromTitleSelection",
      "ZkNewFromContentSelection",
      "ZkCd",
      "ZkBacklinks",
      "ZkLinks",
      "ZkInsertLink",
      "ZkInsertLinkAtSelection",
      "ZkMatch",
      "ZkTags",
    },
    config = function()
      require("zk").setup({
        lsp = {
          auto_attach = {
            enabled = false,
          },
        },
      })
    end,
  },
  -- }}}
}

-- vim: foldmethod=marker ts=2 sts=2 sw=2 et
