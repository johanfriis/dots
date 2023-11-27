local p = require('utils.pack')
local f = require('utils.functions')
local palette = require('rose-pine.palette')

------------------------------------------------------------------------------
--- Docs

-- https://github.com/hrsh7th/nvim-cmp/tree/main


------------------------------------------------------------------------------
--- Config

local sources = {
  { name = 'nvim_lsp', group_index = 1 },
  -- { name = 'copilot' },
  { name = 'snippy', group_index = 2 },
  { name = 'buffer', group_index = 3 },
  { name = 'path', group_index = 3 },
}

local window_style = {
  border = 'single',
  -- border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,FloatBorder:PmenuBorder,Search:None",
  side_padding = 1,
}

------------------------------------------------------------------------------
--- Setup

p.add({
  'cmp-lsp',
  'cmp-buffer',
  'cmp-path',
  'cmp-cmdline',
  'cmp-snippy',
  'snippy',
})
-- p.load('copilot-cmp')

local cmp = require('cmp')
local snippy = require('snippy')

local supertab = function(fallback)
  if cmp.visible() then
    if #cmp.get_entries() == 1 then
      cmp.confirm({ select = true })
    else
      cmp.select_next_item({ behavior = cmp.SelectBehavior.Item })
    end
  elseif snippy.can_expand_or_advance() then
    snippy.expand_or_advance()
  elseif f.has_words_before() then
    cmp.complete()
    if #cmp.get_entries() == 1 then
      cmp.confirm({ select = true })
    end
  else
    fallback()
  end
end

local supertab_shift = function(fallback)
  if cmp.visible() then
    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Item })
  elseif snippy.can_jump(-1) then
    snippy.previous()
  else
    fallback()
  end
end

local super_cr = function(fallback)
  if cmp.visible() and cmp.get_active_entry() then
    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
  else
    cmp.close()
    fallback()
  end
end

local config = {
  sources = sources,

  preselect = cmp.PreselectMode.Item,

  completion = {
    keyword_length = 3,
    autocomplete = false,
    -- completeopt = 'menu,menuone,noselect,noinsert',
  },

  snippet = {
    expand = function(args)
      snippy.expand_snippet(args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping({
      i = supertab,
      s = supertab,
    }),
    ['<S-Tab>'] = supertab_shift,

    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping({
      i = super_cr,
      s = cmp.mapping.confirm({ select = true }),
    }),
  }),

  window = {
    completion = {
      border = window_style.border,
      winhighlight = window_style.winhighlight,
      side_padding = window_style.side_padding,
      col_offset = -3,
      scrollbar = false,
    },
    documentation = window_style,
  },

  experimental = {
    ghost_text = false,
  },

  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)

      local kind_icons = {
        Text = "",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰇽",
        Variable = "󰂡",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "󰅲",
      }

      f.hl("Pmenu", { bg = palette.surface })
      f.hl("PmenuSel", { bg = palette.highlight_med })
      f.hl("PmenuBorder", { fg = palette.iris, bg = palette.surface })

      f.hl("CmpItemAbbrMatch", { fg = palette.gold, bold = true })
      f.hl("CmpItemAbbrMatchFuzzy", { fg = palette.rose, bold = true })
      f.hl("CmpItemMenu", { fg = palette.iris, italic = true })
      f.hl("CmpItemAbbrDeprecated", { fg = "#7E8294", strikethrough = true })

      f.hl({
        "CmpItemKindField",
        "CmpItemKindProperty",
        "CmpItemKindEvent",
        "CmpItemKindText",
        "CmpItemKindEnum",
        "CmpItemKindKeyword",
        "CmpItemKindConstant",
        "CmpItemKindConstructor",
        "CmpItemKindReference",
        "CmpItemKindFunction",
        "CmpItemKindStruct",
        "CmpItemKindClass",
        "CmpItemKindModule",
        "CmpItemKindOperator",
        "CmpItemKindVariable",
        "CmpItemKindFile",
        "CmpItemKindUnit",
        "CmpItemKindSnippet",
        "CmpItemKindFolder",
        "CmpItemKindMethod",
        "CmpItemKindValue",
        "CmpItemKindEnumMember",
        "CmpItemKindInterface",
        "CmpItemKindColor",
        "CmpItemKindTypeParameter",
      }, { fg = palette.highlight_med })

      vim_item.kind = kind_icons[vim_item.kind]
      -- print(entry.source.name)
      vim_item.menu = "      " .. ({
        nvim_lsp = '[LSP]',
        buffer   = '[Buffer]',
        snippy   = '[Snippet]',
        path     = '[Path]',
        cmdline  = '[Cmd]',
      })[entry.source.name]
      return vim_item
    end,
  },
}

cmp.setup(config)

-- cmp.setup.cmdline({ '/', '?' }, {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })
--
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'path', group_index = 1 },
--     { name = 'cmdline', group_index = 2 }
--   }
-- })


-- Set up lspconfig.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
--   capabilities = capabilities
-- }

