-- https://github.com/NeogitOrg/neogit/
-- https://github.com/sindrets/diffview.nvim
-- https://github.com/lewis6991/gitsigns.nvim

return {
    {
        'kdheepak/lazygit.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        lazy = true,
        cmd = 'LazyGit',
    },
    {
        'NeogitOrg/neogit',
        dependencies = {
            'sindrets/diffview.nvim',
            'lewis6991/gitsigns.nvim',
        },
        cmd = 'Neogit',
        config = true,
    },
    {
        'lewis6991/gitsigns.nvim',
        lazy = false,
        event = 'VeryLazy',
        opts = {},
    }
}
