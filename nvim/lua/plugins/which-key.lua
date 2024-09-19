-- https://github.com/folke/which-key.nvim

return {
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            local wk = require('which-key')
            local f = require('utils.functions')
            wk.setup({
                preset = "helix",
                show_help = false,
            })
            wk.add({
                { ",", group = "Fastkey" },
                { ",b", ':lua require("telescope.builtin").buffers()<CR>', desc = "Explore [Netrw]" },
                { ",d", ":Trouble lsp_definitions<CR>", desc = "Definitions [LSP]" },
                { ",e", ":Explore<CR>", desc = "Explore [Netrw]" },
                { ",f", ":Telescope find_files<CR>", desc = "Files [Pick]" },
                { ",r", ":Trouble lsp_references<CR>", desc = "References [LSP]" },
                { ",u", ":UndotreeToggle<CR>", desc = "Undotree" },

                { "<leader>b", group = "Buffer" },
                { "<leader>ba", ":b#<CR>", desc = "Alternate" },
                { "<leader>bh", ':lua require("smart-list").swap_buf_left()<CR>', desc = "Swap Left" },
                { "<leader>bj", ':lua require("smart-list").swap_buf_down()<CR>', desc = "Swap Down" },
                { "<leader>bk", ':lua require("smart-list").swap_buf_up()<CR>', desc = "Swap Up" },
                { "<leader>bl", ':lua require("smart-list").swap_buf_right()<CR>', desc = "Swap Right" },
                { "<leader>bs", f.new_scratch_buffer, desc = "Scratch" },

                { "<leader>d", group = "Dev" },
                { "<leader>dc", vim.lsp.buf.code_action, desc = "Code Action [LSP]" },
                { "<leader>dd", vim.diagnostic.open_float, desc = "Diagnostics [LSP]" },
                { "<leader>df", vim.lsp.buf.format, desc = "Format [LSP]" },
                { "<leader>dg", ":LazyGit<CR>", desc = "LazyGit" },
                { "<leader>dr", vim.lsp.buf.rename, desc = "Rename [LSP]" },
                { "<leader>ds", vim.lsp.buf.signature_help, desc = "Signature Help [LSP]" },
                { "<leader>dv", ':lua <C-r>"<CR>', desc = 'Eval " register' },

                -- { "<leader>j", group = "Journal" },
                -- { "<leader>jD", ":Telekasten find_daily_notes<CR>", desc = "Find Daily" },
                -- { "<leader>jW", ":Telekasten find_weekly_notes<CR>", desc = "Find Weekly" },
                -- { "<leader>jc", ":Telekasten show_calendar<CR>", desc = "Calendar" },
                -- { "<leader>jd", ":Telekasten goto_today<CR>", desc = "Daily" },
                -- { "<leader>jn", ":Telekasten new_note<CR>", desc = "New" },
                -- { "<leader>jo", ":Telekasten find_notes<CR>", desc = "Open" },
                -- { "<leader>js", ":Telekasten search_notes<CR>", desc = "Search" },
                -- { "<leader>jt", ":Telekasten show_tags<CR>", desc = "Tags" },
                -- { "<leader>jv", ":Telekasten switch_vault<CR>", desc = "Vault" },
                -- { "<leader>jw", ":Telekasten goto_thisweek<CR>", desc = "Weekly" },

                { "<leader>p", group = "Pick" },
                { "<leader>pa", ':lua require("utils.pickers").adjacent()<CR>', desc = "Adjacent File" },
                { "<leader>pg", ":Telescope git_files<CR>", desc = "Git File" },
                { "<leader>pr", ":Telescope oldfiles<CR>", desc = "Recent File" },
                { "<leader>ps", ":Telescope live_grep<CR>", desc = "Search File" },
                { "<leader>pt", ":Telescope current_buffer_fuzzy_finder<CR>", desc = "This File" },
                { "<leader>pv", ":Telescope help_tags<CR>", desc = "Vim Help" },

                { "<leader>t", group = "Toggle" },
                { "<leader>tc", ":setlocal cursorline!<CR>", desc = "Toggle `cursorline`" },
                { "<leader>td", ':lua require("utils.functions").toggle_diagnostic()<CR>', desc = "Toggle Diagnostic" },
                { "<leader>th", ":setlocal hlsearch!<CR>", desc = "Toggle `hlsearch`" },
                { "<leader>ti", ":setlocal ignorecase!<CR>", desc = "Toggle `ignorecase`" },
                { "<leader>tl", ":setlocal list!<CR>", desc = "Toggle `list`" },
                { "<leader>tn", ":setlocal number!<CR>", desc = "Toggle `number`" },
                { "<leader>tr", ":setlocal relativenumber!<CR>", desc = "Toggle `relativenumber`" },
                { "<leader>ts", ":setlocal spell!<CR>", desc = "Toggle `spell`" },
                { "<leader>tv", ":setlocal cursorcolumn!<CR>", desc = "Toggle `cursorcolumn`" },
                { "<leader>tw", ":setlocal wrap!<CR>", desc = "Toggle `wrap`" },
                { "<leader>tx", ':lua require("utils.functions").toggle_colorcolumn()<CR>', desc = "Toggle colorcolumn" },
                { "<leader>tz", ":ZenMode<CR>", desc = "Toggle zen mode" },
            })
        end,
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer local keymaps"
            }
        }
    },
}

-- vim: foldmethod=marker

