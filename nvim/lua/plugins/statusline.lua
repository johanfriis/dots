-- https://github.com/freddiehaddad/feline.nvim
-- https://github.com/freddiehaddad/nvim/blob/main/lua/plugins/feline.lua
-- https://gist.github.com/Toufyx/d6b48a0a12ceff02268be49db0a97ddf

require('utils.statusline')

local THEME = {
    bg = 'base',
    fg = 'text'
}

local MODE_COLORS = {
  ['NORMAL'] = 'pine',
  ['COMMAND'] = 'foam',
  ['INSERT'] = 'love',
  ['REPLACE'] = 'love',
  ['LINES'] = 'gold',
  ['VISUAL'] = 'gold',
  ['OP'] = 'iris',
  ['BLOCK'] = 'iris',
  ['V-REPLACE'] = 'iris',
  ['ENTER'] = 'iris',
  ['MORE'] = 'iris',
  ['SELECT'] = 'iris',
  ['SHELL'] = 'iris',
  ['TERM'] = 'iris',
  ['NONE'] = 'iris',
}

local config = function(_, opts)
    local feline = require('feline')
    local palette = require('rose-pine.palette')
    local lsp = require('feline.providers.lsp')
    local file = require('feline.providers.file')
    local macro = require('feline.providers.cursor').macro
    local position = require('feline.providers.cursor').position
    local percentage = require('feline.providers.cursor').line_percentage
    local mode_color = require('feline.providers.vi_mode').get_mode_color

    local mode = function()
        return vim.fn.mode()
    end

    local filename = function(c)
        return file.file_info(c, {
            type = 'relative',
            file_readonly_icon = '  ',
            file_modified_icon = '+',
        })
    end

    local branch = function()
        local b = vim.b.gitsigns_head
        if b ~= nil then
            return ' ' .. vim.b.gitsigns_head
            -- return ' ' .. vim.b.gitsigns_head .. ' ' .. vim.b.gitsigns_status
        else
            return ''
        end
    end

    local cursor = function(c)
        return position(c, {
            padding = true
        }) .. '  ' .. percentage()
    end


    local active = {
        {
            {
                name = 'mode',
                provider = provide(mode, wrap),
                right_sep = 'slant_right',
                hl = function()
                    return { fg = 'base', bg = mode_color() }
                end,
            },
            {
                name = 'filename',
                provider = provide(filename, wrap_left),
                right_sep = 'slant_right',
                hl = { fg = 'base', bg = 'iris' },
            },
            {
                name = 'branch',
                provider = provide(branch, wrap_left),
                enabled = function() return branch() ~= '' end,
                right_sep = 'slant_right',
                hl = { fg = 'base', bg = 'rose' },
            },
        },
        {
            {
                name = 'macro',
                provider = provide(macro, wrap_right),
                enabled = function() return macro() ~= '' end,
                left_sep = 'slant_left',
                hl = { fg = 'base', bg = 'iris' },
            },
            {
                name = 'lsp',
                provider = provide(lsp.lsp_client_names, wrap_right),
                enabled = lsp.is_lsp_attached,
                left_sep = 'slant_left',
                hl = { fg = 'base', bg = 'gold' },
            },
            {
                name = 'cursor',
                provider = provide(cursor, wrap),
                left_sep = 'slant_left',
                hl = { fg = 'base', bg = 'iris' },
            },
        },
    }

    local inactive = {
        {
            {
                name = 'filename',
                provider = provide(filename, wrap),
                right_sep = 'slant_right',
                hl = { fg = 'iris', bg = 'surface' },
            }
        },
        { }
    }

    opts.components = { active = active, inactive = inactive }
    opts.vi_mode_colors = MODE_COLORS
    opts.theme = vim.tbl_extend('force', THEME, palette)

    feline.setup(opts)
end

return {
    {
        'freddiehaddad/feline.nvim',
        depdendencies = {
            'lewis6991/gitsigns.nvim',
            { 'rose-pine/neovim', name = 'rose-pine' },
        },
        enabled = true,
        opts = {
            force_inactive = { filetypes = { '^help$' } },
        },
        config = config,
    }
}
