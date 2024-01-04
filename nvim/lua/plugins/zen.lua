return {
    "folke/zen-mode.nvim",
    dependencies = {
        'folke/twilight.nvim',
    },
    opts = {
        window = {
            width = 120,
            options = {
                wrap = true,
                linebreak = true,
            }
        },
        plugins = {
            gitsigns = { enabled = false },
            twilight = { enabled = true },
        },
    },
}
