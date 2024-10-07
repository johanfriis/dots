-- https://github.com/zbirenbaum/copilot.lua
return {
    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        opts = {
            panel = {
                auto_refresh = false,
                layout = {
                    position = 'right'
                },
            },
            suggestion = {
                auto_trigger = true,
                keymap = {
                    accept = '<M-CR>',
                },
            },
            filetypes = {
                markdown = false
            }
        },
    },
}
