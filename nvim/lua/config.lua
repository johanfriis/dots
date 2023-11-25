-- ============================================================================
do -- {{{ functions ===

  -- --------------------------------------------------------------------------
  -- {{{ Make it easier to create augroups ---

  function augroup(name, autocmds)
    local group = api.nvim_create_augroup(name, {})
    for event, opts in pairs(autocmds) do
      opts.group = group
      api.nvim_create_autocmd(event, opts)
    end
  end

  -- }}}


  -- --------------------------------------------------------------------------
  -- {{{ Make it easier to create mappings with sensible defaults ---

  local default_keymap_opts = {
    noremap = true,
    silent = true,
    expr = false,
    nowait = false,
    script = false,
    unique = false
  }

  function map(mode, keys, cmd, opts)
    local o = tbl_deep_extend('force', default_keymap_opts, opts or {})
    keymap.set(mode, keys, cmd, o)
  end

  -- }}}


  -- --------------------------------------------------------------------------
  -- {{{ simple highlighting ---

  -- fg (or foreground), bg (or background), sp (or special), blend,
  -- bold, standout, underline, undercurl, underdouble, underdotted,
  -- underdashed, strikethrough, italic, reverse, nocombine, link,
  -- ctermfg, ctermbg, cterm,

  function hl(group, definitions)
    api.nvim_set_hl(0, group, definitions or {})
  end
  -- }}}


  -- --------------------------------------------------------------------------
  -- {{{ Create `<Leader>` mappings ---
  --
  function leader(mode, suffix, rhs, desc, opts)
    opts = opts or {}
    opts.desc = desc
    keymap.set(mode, '<Leader>' .. suffix, rhs, opts)
  end
  -- }}}


  -- --------------------------------------------------------------------------
  -- {{{ Colorscheme toggler ---
  --
  function toggle_colorscheme(light, dark)
    print('I am switching color')
    if opt.background == "dark" then
      api.nvim_set_option("background", "light")
      cmd.colorscheme(light)
    else
      api.nvim_set_option("background", "dark")
      cmd.colorscheme(dark)
    end
  end
  -- }}}


  -- --------------------------------------------------------------------------
  -- {{{ Toggle diagnostic for current buffer ---

  -- Diagnostic state per buffer
  local buffer_diagnostic_state = {}

  _G.toggle_diagnostic = function()
    local buf_id = api.nvim_get_current_buf()
    local buf_state = buffer_diagnostic_state[buf_id]
    if buf_state == nil then buf_state = true end

    if buf_state then
      diagnostic.disable(buf_id)
    else
      diagnostic.enable(buf_id)
    end

    local new_buf_state = not buf_state
    buffer_diagnostic_state[buf_id] = new_buf_state

    return new_buf_state and '  diagnostic' or 'nodiagnostic'
  end
  -- }}}


  -- --------------------------------------------------------------------------
  -- {{{ Toggle colorcolumn for current buffer ---

  _G.toggle_colorcolumn = function()
    --  local current_state = api.nvim_get_option_value('colorcolumn', {})
    --  local default = '+1'
    --  local on_state = H.colorcolumn_state or default
    --if buf_state ~= nil then buf_state = nil end

    if api.nvim_get_option_value('colorcolumn', {}) == '' then
      api.nvim_set_option_value('colorcolumn', '+1', {})
    else
      api.nvim_set_option_value('colorcolumn', '', {})
    end
  end
  -- }}}


  -- --------------------------------------------------------------------------
  -- {{{ Action for `<CR>` which respects completion and autopairs ---

  -- Mapping should be done after everything else because `<CR>` can be
  -- overridden by something else (notably 'mini-pairs.lua'). This should be an
  -- expression mapping:
  -- vim.api.nvim_set_keymap('i', '<CR>', 'v:lua._cr_action()', { expr = true })
  --
  -- Its current logic:
  -- - If no popup menu is visible, use "no popup keys" getter. This is where
  --   autopairs plugin should be used. Like with 'nvim-autopairs'
  --   `get_nopopup_keys` is simply `npairs.autopairs_cr`.
  -- - If popup menu is visible:
  --     - If item is selected, execute "confirm popup" action and close
  --       popup. This is where completion engine takes care of snippet expanding
  --       and more.
  --     - If item is not selected, close popup and execute '<CR>'. Reasoning
  --       behind this is to explicitly select desired completion (currently this
  --       is also done with one '<Tab>' keystroke).

  local cr_cr_keys = {
    ['cr'] = vim.api.nvim_replace_termcodes('<CR>', true, true, true),
    ['ctrl-y'] = vim.api.nvim_replace_termcodes('<C-y>', true, true, true),
    ['ctrl-y_cr'] = vim.api.nvim_replace_termcodes('<C-y><CR>', true, true, true),
  }

  _G.cr_action = function()
    if vim.fn.pumvisible() ~= 0 then
      local item_selected = vim.fn.complete_info()['selected'] ~= -1
      return item_selected and cr_cr_keys['ctrl-y'] or cr_keys['ctrl-y_cr']
    else
      return require('mini.pairs').cr()
    end
  end

  -- }}}


  -- --------------------------------------------------------------------------
  -- {{{ Create scratch buffer and focus on it ---

  _G.new_scratch_buffer = function()
    local buf_id = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_win_set_buf(0, buf_id)
    return buf_id
  end

  -- }}}


  -- --------------------------------------------------------------------------
  -- {{{ Toggle quickfix window ---

  _G.toggle_quickfix = function()
    local quickfix_wins = tbl_filter(
      function(win_id) return fn.getwininfo(win_id)[1].quickfix == 1 end,
      api.nvim_tabpage_list_wins(0)
    )

    local command = #quickfix_wins == 0 and 'copen' or 'cclose'
    cmd(command)
  end

  -- }}}


  -- --------------------------------------------------------------------------
  -- {{{ Toggle LazyGit ---

  _G.open_lazygit = function()
    cmd [[tabedit]]
    cmd [[setlocal nonumber signcolumn=no]]

    -- Unset vim environment variables to be able to call `vim` without errors
    -- Use custom `--git-dir` and `--work-tree` to be able to open inside
    -- symlinked submodules
    fn.termopen('VIMRUNTIME= VIM= lazygit --git-dir=$(git rev-parse --git-dir) --work-tree=$(realpath .)', {
      on_exit = function()
        cmd [[silent! :checktime]]
        cmd [[ silent! :bw ]]
      end,
    })
    cmd [[startinsert]]
    b.minipairs_disable = true
  end

  -- }}}

end
-- }}}


-- ============================================================================
do -- {{{ mappings ===

  g.mapleader = ' '

  -- fix yanking and pasting
  map({'n', 'x'}, 'gy', '"+y', { desc = 'Yank to system clipboard' })
  map({'n', 'x'}, 'gyy', '"+yy', { desc = 'Yank to system clipboard' })
  map('n', 'gp', '"+p', { desc = 'Paste from system clipboard' })
  -- Paste in visual with P to not copy selected text (:h v_P)
  map('x', 'gp', '"+P', { desc = 'Paste from system clipboard' })

  -- Move by visible lines
  map({ 'n', 'x' }, 'j', [[v:count == 0 ? 'gj' : 'j']], { expr = true })
  map({ 'n', 'x' }, 'k', [[v:count == 0 ? 'gk' : 'k']], { expr = true })

  -- some readline mappings in insert and command mode
  map({'i', 'c'}, '<C-b>', '<Left>',  { silent = false, desc = 'Left' })
  map({'i', 'c'}, '<C-f>', '<Right>', { silent = false, desc = 'Right' })
  map({'i', 'c'}, '<C-a>', '<Home>',  { silent = false, desc = 'Home' })
  map({'i', 'c'}, '<C-e>', '<End>',   { silent = false, desc = 'End' })

  -- Disable `s` shortcut (use `cl` instead) for safer usage of 'mini.surround'
  map({'n', 'x'}, [[s]], [[<Nop>]])

  -- Better command history navigation
  map('c', '<C-p>', '<Up>', { silent = false })
  map('c', '<C-n>', '<Down>', { silent = false })

  -- delegate 'CR' to a customer function
  map('i', '<CR>', cr_action)

end
-- }}}


-- ============================================================================
do -- {{{ leader mappings ===


  -- leader groups for use with mini.clues
  _G.leader_groups = {
    { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
    { mode = 'n', keys = '<Leader>c', desc = '+Code' },
    { mode = 'n', keys = '<Leader>e', desc = '+Explore' },
    { mode = 'n', keys = '<Leader>f', desc = '+Find' },
    { mode = 'n', keys = '<Leader>g', desc = '+Git' },
    { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
    { mode = 'n', keys = '<Leader>t', desc = '+Toggle' },
    -- { mode = 'n', keys = '<Leader>L', desc = '+Lua' },
    -- { mode = 'n', keys = '<Leader>m', desc = '+Map' },
    -- { mode = 'n', keys = '<Leader>o', desc = '+Other' },
    -- { mode = 'n', keys = '<Leader>r', desc = '+R' },
    -- { mode = 'n', keys = '<Leader>t', desc = '+Terminal/Minitest' },
    -- { mode = 'n', keys = '<Leader>T', desc = '+Test' },
    --
    -- { mode = 'x', keys = '<Leader>l', desc = '+LSP' },
    -- { mode = 'x', keys = '<Leader>r', desc = '+R' },
  }

  -- 'b' is for 'buffer'
  leader('n', 'ba', [[<Cmd>b#<CR>]],                                 'Alternate')
--  leader('n', 'bd', [[<Cmd>lua MiniBufremove.delete()<CR>]],         'Delete')
--  leader('n', 'bD', [[<Cmd>lua MiniBufremove.delete(0, true)<CR>]],  'Delete!')
  leader('n', 'bs', [[<Cmd>lua new_scratch_buffer()<CR>]],         'Scratch')
--  leader('n', 'bw', [[<Cmd>lua MiniBufremove.wipeout()<CR>]],        'Wipeout')
--  leader('n', 'bW', [[<Cmd>lua MiniBufremove.wipeout(0, true)<CR>]], 'Wipeout!')

  -- 'c' is for 'code'

  -- 't' is for 'toggle'
  leader('n', 'td',  '<Cmd>lua toggle_diagnostic()<CR>',         'Toggle diagnostic')
  leader('n', 'th',  '<Cmd>let v:hlsearch = 1 - v:hlsearch<CR>', 'Toggle search highlight')
  leader('n', 'ti',  '<Cmd>setlocal ignorecase!<CR>',            "Toggle 'ignorecase'")
  leader('n', 'tl',  '<Cmd>setlocal list!<CR>',                  "Toggle 'list'")
  leader('n', 'tn',  '<Cmd>setlocal number!<CR>',                "Toggle 'number'")
  leader('n', 'tr',  '<Cmd>setlocal relativenumber!<CR>',        "Toggle 'relativenumber'")
  leader('n', 'ts',  '<Cmd>setlocal spell!<CR>',                 "Toggle 'spell'")
  leader('n', 'tw',  '<Cmd>setlocal wrap!<CR>',                  "Toggle 'wrap'")
  leader('n', 'tC',  '<Cmd>lua toggle_colorcolumn()<CR>',        'Toggle colorcolumn')
  leader('n', 'tcl', '<Cmd>setlocal cursorline!<CR>',            "Toggle 'cursorline'")
  leader('n', 'tcc', '<Cmd>setlocal cursorcolumn!<CR>',          "Toggle 'cursorcolumn'")


  -- 'e' is for 'explore'
  leader('n', 'ed', [[<Cmd>lua MiniFiles.open()<CR>]],                             'Directory')
  leader('n', 'ef', [[<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>]], 'File directory')
  -- TODO maybe we don't want this one?
  leader('n', 'el', [[<Cmd>lua MiniFiles.open('~/dev/notes/log')<CR>]],            'ZK Logs')
  leader('n', 'eq', [[<Cmd>lua G.toggle_quickfix()<CR>]],                          'Quickfix')

  -- 'f' is for 'fuzzy find'
  leader('n', 'f/', [[<Cmd>Pick history scope='/'<CR>]],                             '"/" history')
  leader('n', 'f:', [[<Cmd>Pick history scope=':'<CR>]],                             '":" history')
  leader('n', 'fa', [[<Cmd>Pick git_hunks scope='staged'<CR>]],                      'Added hunks (all)')
  leader('n', 'fA', [[<Cmd>Pick git_hunks path='%' scope='staged'<CR>]],             'Added hunks (current)')
  leader('n', 'fb', [[<Cmd>Pick buffers<CR>]],                                       'Open buffers')
  leader('n', 'fc', [[<Cmd>Pick git_commits choose_type='show_patch'<CR>]],          'Commits')
  leader('n', 'fC', [[<Cmd>Pick git_commits path='%' choose_type='show_patch'<CR>]], 'Buffer commits')
  leader('n', 'fd', [[<Cmd>Pick diagnostic scope='all'<CR>]],                        'Diagnostic workspace')
  leader('n', 'fD', [[<Cmd>Pick diagnostic scope='current'<CR>]],                    'Diagnostic buffer')
  leader('n', 'ff', [[<Cmd>Pick files<CR>]],                                         'Files')
  leader('n', 'fg', [[<Cmd>Pick grep_live<CR>]],                                     'Grep live')
  leader('n', 'fG', [[<Cmd>Pick grep pattern='<cword>'<CR>]],                        'Grep current word')
  leader('n', 'fh', [[<Cmd>Pick help<CR>]],                                          'Help tags')
  leader('n', 'fH', [[<Cmd>Pick hl_groups<CR>]],                                     'Highlight groups')
  leader('n', 'fl', [[<Cmd>Pick buf_lines scope='all'<CR>]],                         'Lines (all)')
  leader('n', 'fL', [[<Cmd>Pick buf_lines scope='current'<CR>]],                     'Lines (current)')
  leader('n', 'fm', [[<Cmd>Pick git_hunks<CR>]],                                     'Modified hunks (all)')
  leader('n', 'fM', [[<Cmd>Pick git_hunks path='%'<CR>]],                            'Modified hunks (current)')
  leader('n', 'fo', [[<Cmd>Pick oldfiles<CR>]],                                      'Old files')
  leader('n', 'fO', [[<Cmd>Pick options<CR>]],                                       'Options')
  leader('n', 'fr', [[<Cmd>Pick resume<CR>]],                                        'Resume')
  leader('n', 'fR', [[<Cmd>Pick lsp scope='references'<CR>]],                        'References (LSP)')
  leader('n', 'fs', [[<Cmd>Pick lsp scope='workspace_symbol'<CR>]],                  'Symbols workspace (LSP)')
  leader('n', 'fS', [[<Cmd>Pick lsp scope='document_symbol'<CR>]],                   'Symbols buffer (LSP)')
  -- TODO add a picker for TODO / FIXME / etc ...

  -- g is for git
--  leader('n', 'gA', [[<Cmd>lua require("gitsigns").stage_buffer()<CR>]],        'Add buffer')
--  leader('n', 'ga', [[<Cmd>lua require("gitsigns").stage_hunk()<CR>]],          'Add (stage) hunk')
--  leader('n', 'gb', [[<Cmd>lua require("gitsigns").blame_line()<CR>]],          'Blame line')
  leader('n', 'gg', [[<Cmd>lua open_lazygit()<CR>]],                          'Git tab')
--  leader('n', 'gp', [[<Cmd>lua require("gitsigns").preview_hunk()<CR>]],        'Preview hunk')
--  leader('n', 'gq', [[<Cmd>lua require("gitsigns").setqflist()<CR>:copen<CR>]], 'Quickfix hunks')
--  leader('n', 'gu', [[<Cmd>lua require("gitsigns").undo_stage_hunk()<CR>]],     'Undo stage hunk')
--  leader('n', 'gx', [[<Cmd>lua require("gitsigns").reset_hunk()<CR>]],          'Discard (reset) hunk')
--  leader('n', 'gX', [[<Cmd>lua require("gitsigns").reset_buffer()<CR>]],        'Discard (reset) buffer')

  -- l is for 'LSP' (Language Server Protocol)
  leader('n', 'la', [[<Cmd>lua vim.lsp.buf.signature_help()<CR>]], 'Arguments popup')
  leader('n', 'ld', [[<Cmd>lua vim.diagnostic.open_float()<CR>]],  'Diagnostics popup')
  leader('n', 'lf', [[<Cmd>lua vim.lsp.buf.formatting()<CR>]],     'Format')
  leader('n', 'li', [[<Cmd>lua vim.lsp.buf.hover()<CR>]],          'Information')
  leader('n', 'lj', [[<Cmd>lua vim.diagnostic.goto_next()<CR>]],   'Next diagnostic')
  leader('n', 'lk', [[<Cmd>lua vim.diagnostic.goto_prev()<CR>]],   'Prev diagnostic')
  leader('n', 'lR', [[<Cmd>lua vim.lsp.buf.references()<CR>]],     'References')
  leader('n', 'lr', [[<Cmd>lua vim.lsp.buf.rename()<CR>]],         'Rename')
  leader('n', 'ls', [[<Cmd>lua vim.lsp.buf.definition()<CR>]],     'Source definition')

  leader('x', 'lf', [[<Cmd>lua vim.lsp.buf.format()<CR><Esc>]],   'Format selection')

end
-- }}}


-- ============================================================================
do -- {{{ general options setup ===
  opt.mouse        = 'a'                                        -- Enable mouse
  opt.mousescroll  = 'ver:25,hor:6'                             -- Customize mouse scroll
  opt.switchbuf    = 'usetab'                                   -- Use already opened buffers when switching
  opt.backup       = false                                      -- Don't store backup
  opt.writebackup  = false                                      -- Don't store backup

  opt.undodir      = fn.stdpath('state') .. '/undo'             -- Set directory for persistent undo
  opt.undofile     = true                                       -- Enable persistent undo

  opt.shadafile    = fn.stdpath('state') .. '/shada/main.shada' -- Set directory for 'shadafile'
  opt.shada        = [[!,'100,<50,s10,h,f1]]                    -- Add file marks to shadafile


  opt.timeout      = true                                       -- wait for timeout
  opt.timeoutlen   = 200                                        -- only wait for this long

  cmd [[filetype plugin indent on]]                             -- Enable all filetype plugins

end
-- }}}


-- ============================================================================
do -- {{{ appearance options setup ===
  opt.laststatus = 2      -- Always show statusline

  -- mode | file [modified?] [readonly?]
  local left = '%2{mode()} | %f %m %r'
  local center = ''
  -- spell [lang] linenr,colnr percentage
  local right = '%{&spelllang} %y %8(%l,%c%) %4p%%'
  opt.statusline = left .. ' %= ' .. center .. ' %= ' .. right

  -- Colors -----------------------------------------------------------------
  -- render lots of colors
  opt.termguicolors = true
  cmd.colorscheme 'rose-pine-moon'
  local toggle = function ()
    toggle_colorscheme('rose-pine-dawn', 'rose-pine-moon')
  end
  leader('n', 'tu', toggle, 'Toggle colorscheme')


  -- Enable syntax highlighing if it wasn't already (as it is time consuming)
  --    if vim.fn.exists("syntax_on") ~= 1 then
  --        vim.cmd([[syntax enable]])
  --    end

  -- flash text on yank
  augroup('Highlights', {
    TextYankPost = {
      callback = function() highlight.on_yank() end,
    },
  })

  opt.showtabline   = 2        -- Always show tabline

  opt.showmode      = false    -- Don't show mode in command line
  opt.cmdheight     = 0        -- Don't show commandline unless in use
  opt.shortmess     = 'a' ..   -- Include a lot of abbreviations
                      'o' ..   -- Overwrite write / read messages
                      'O' ..   -- Overwrite reading message
                      'W' ..   -- Don't notify for write
                      'F' ..   -- Don't give file info while editing
                      'c' ..   -- Don't give |ins-completion-menu| messages
                      'I'      -- Don't show intro message

  opt.number        = true            -- Show line numbers
  opt.signcolumn    = 'yes'           -- Always show signcolumn or it would frequently shift

  opt.cursorline    = true            -- Enable highlighting of the current line
  opt.textwidth     = 80              -- Set the desired maximum textwidth
  opt.colorcolumn   = '+1'            -- Draw colored column one step to the right of desired maximum width

  opt.breakindent   = true            -- Indent wrapped lines to match line start
  opt.linebreak     = true            -- Wrap long lines at 'breakat' (if 'wrap' is set)
  opt.wrap          = false           -- Display long lines as just one line

  opt.splitbelow    = true            -- Horizontal splits will be below
  opt.splitright    = true            -- Vertical splits will be to the right


  opt.winblend      = 4               -- Make floating windows slightly transparent
  opt.pumblend      = 4               -- Make builtin completion menus slightly transparent
  opt.pumheight     = 10              -- Make popup menu smaller

  -- stylua: ignore start
  opt.fillchars     = 'eob: ,' ..     -- Disable '~' at eob
                      'fold: ,' ..    -- Disable fold line '╌'
                      'horiz:═,' ..   -- Pretty (double) lines
                      'horizdown:╦,' ..
                      'horizup:╩,' ..
                      'vert:║,' ..
                      'verthoriz:╬,' ..
                      'vertleft:╣,' ..
                      'vertright:╠' ..
                      ''
  -- stylua: ignore end
end
-- }}}


-- ============================================================================
do -- {{{ editing options setup ===

  opt.shiftwidth    = 2         -- Use this number of spaces for indentation
  opt.tabstop       = 2         -- Insert 4 spaces for a tab
  opt.expandtab     = true      -- Convert tabs to spaces

  opt.autoindent    = true      -- Use auto indent
  opt.smartindent   = true      -- Make indenting smart

  opt.ignorecase    = true      -- Ignore case when searching (use `\C` to force not doing that)
  opt.infercase     = true      -- Infer letter cases for a richer built-in keyword completion
  opt.smartcase     = true      -- Don't ignore case when searching if pattern has upper case

  opt.incsearch     = true      -- Show search results while typing
  opt.hlsearch      = false     -- Disable highlighting of all search matches

  opt.virtualedit   = 'block'   -- Allow going past the end of line in visual block mode
  opt.iskeyword:append('-')     -- Treat dash and underscore separated words as a word text object

  -- Define pattern for a start of 'numbered' list. This is responsible for
  -- correct formatting of lists when using `gw`. This basically reads as 'at
  -- least one special character (digit, -, +, *) possibly followed some
  -- punctuation (. or `)`) followed by at least one space is a start of list
  -- item'
  opt.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

  opt.formatoptions = 'r' ..    -- Enter inserts commentleader
                      'q' ..    -- "gq" formats comments
                      'n' ..    -- recognize numbered lists
                      'l' ..    -- don't break already long lines
                      '1' ..    -- break lines before one letter words
                      'j' ..    -- remove comment leader when joining lines
                      'p' ..    -- don't break following periods
                      ''

  -- prevent 'o' from opening comments
  augroup('FormatOptions', {
    FileType = {
      pattern = { '*' },
      command = [[setlocal formatoptions-=c formatoptions-=o]]
    },
  })
end
-- }}}


-- ============================================================================
do -- {{{ tmux setup ===

  --     https://github.com/aserowy/tmux.nvim
  cmd [[packadd tmux.nvim]]
  require 'tmux'.setup {
    resize = {
      enable_default_keybindings = false,
    }
  }

end
-- }}}


-- ============================================================================
do -- {{{ mini.bracketed setup ===

  cmd [[packadd mini.bracketed]]
  require 'mini.bracketed'.setup {}

end
-- }}}


-- ============================================================================
do -- {{{ mini.clue setup ===

  cmd [[packadd mini.clue]]
  local miniclue = require 'mini.clue'
  miniclue.setup {
    clues = {
      _G.leader_groups,
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },

    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- mini.bracketed
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },
    window = {
      delay = 200,
      config = {
        width = 'auto',
      }
    },
  }


end
-- }}}


-- ============================================================================
do -- {{{ mini.comment setup ===

  cmd [[packadd mini.comment]]
  require 'mini.comment'.setup {}

end
-- }}}


-- ============================================================================
do -- {{{ mini.hipatterns setup ===

  cmd [[packadd mini.hipatterns]]
  cmd [[packadd mini.extra]]

  local hipatterns = require 'mini.hipatterns'
  local MiniExtra = require 'mini.extra'

  local hi_words = MiniExtra.gen_highlighter.words

  hipatterns.setup({
    highlighters = {
      fixme = hi_words({ 'FIXME' }, 'MiniHipatternsFixme'),
      hack  = hi_words({ 'HACK' },  'MiniHipatternsHack'),
      todo  = hi_words({ 'TODO' },  'MiniHipatternsTodo'),
      note  = hi_words({ 'NOTE' },  'MiniHipatternsNote'),

      hex_color = hipatterns.gen_highlighter.hex_color({
        style = '#', -- TODO once 0.10 comes around, change to 'inline'
      }),
    }
  })

end
-- }}}


-- ============================================================================
do -- {{{ mini.files setup ===

  cmd [[packadd mini.files]]

  local MiniFiles = require 'mini.files'

  local show_dotfiles = false
  local filter_show = function(fs_entry) return true end
  local filter_hide = function(fs_entry)
    return not startswith(fs_entry.name, '.')
  end

  local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    local new_filter = show_dotfiles and filter_show or filter_hide
    MiniFiles.refresh({ content = { filter = new_filter } })
  end

  local files_set_cwd = function(path)
    -- Works only if cursor is on the valid file system entry
    local cur_entry_path = MiniFiles.get_fs_entry().path
    local cur_directory = fs.dirname(cur_entry_path)
    vim.fn.chdir(cur_directory)
    print("Updated CWD to " .. cur_directory)
  end


  local minifiles_toggle = function()
    if not MiniFiles.close() then MiniFiles.open(api.nvim_buf_get_name(0)) end
  end

  augroup('MiniFilesUser', {
    User = {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        map('n', 'gr', files_set_cwd, { buffer = args.data.buf_id })
        map('n', 'g.', toggle_dotfiles, { buffer = buf_id })
        map('n', '<CR>', MiniFiles.go_in, { buffer = args.data.buf_id })
        map('n', '<esc>', minifiles_toggle, { buffer = args.data.buf_id })
      end
    },
  })

  MiniFiles.setup { 
    content = {
      filter = filter_hide
    }
  } 

end
-- }}}


-- ============================================================================
do -- {{{ mini.jump(2d) setup ===

  cmd [[packadd mini.jump]]
  cmd [[packadd mini.jump2d]]

  require 'mini.jump'.setup {}
  require 'mini.jump2d'.setup {
    labels = 'fjdksla;ghcnrueiwo',
  }

  hl('MiniJump2dSpot', { fg = '#eb6f92', bg = '#232136' })

end
-- }}}


-- ============================================================================
do -- {{{ mini.misc / extra setup ===

  cmd [[packadd mini.misc]]
  cmd [[packadd mini.extra]]

  require 'mini.misc'.setup {
    make_global = { 'put', 'put_text' }
  }

  MiniMisc.setup_auto_root()
  MiniMisc.setup_restore_cursor()

  require 'mini.extra'.setup {}

end
-- }}}


-- ============================================================================
do -- {{{ mini.move setup ===

  cmd [[packadd mini.move]]
  require 'mini.move'.setup {}

end
-- }}}


-- ============================================================================
do -- {{{ mini.pairs setup ===

  cmd [[packadd mini.pairs]]
  require 'mini.pairs'.setup {
    modes = {
      insert = true,
      command = true,
      terminal = false,
    }
  }

end
-- }}}


-- ============================================================================
do -- {{{ mini.pick setup ===

  cmd [[packadd mini.pick]]
  require 'mini.pick'.setup { }

  ui.select = MiniPick.ui_select
  map('n', ',', [[<Cmd>Pick buf_lines scope='current'<CR>]], { nowait = true })
  hl('MiniPickMatchCurrent', { fg = '#eb6f92', bg = '#232136' })

end
-- }}}


-- ============================================================================
do -- {{{ mini.comment setup ===

  cmd [[packadd mini.comment]]
  require 'mini.comment'.setup {}

end
-- }}}


-- ============================================================================
do -- {{{ mini.sessions setup ===

  cmd [[packadd mini.sessions]]
  require 'mini.sessions'.setup {
    autowrite = true,
    directory = vim.fn.stdpath('state') .. '/session',
    file = '',
  }

end
-- }}}


-- ============================================================================
do -- {{{ mini.starter setup ===

  cmd [[packadd mini.starter]]
  require 'mini.starter'.setup {
    footer = ''
  }

end
-- }}}


-- ============================================================================
do -- {{{ mini.surround setup ===

  cmd [[packadd mini.surround]]
  require 'mini.surround'.setup {}

end
-- }}}


-- ============================================================================
do -- {{{ mini.tabline setup ===

  cmd [[packadd mini.tabline]]
  require 'mini.tabline'.setup {
      show_icons = false
  }

end
-- }}}


-- ============================================================================
do -- {{{ mini.trailspace setup ===

  cmd [[packadd mini.trailspace]]
  require 'mini.trailspace'.setup {}

end
-- }}}


-- ============================================================================
do -- {{{ vim-matchup setup ===

  -- cmd [[packadd vim-matchup]]
  -- require 'match-up'.setup {}

end
-- }}}


-- ============================================================================
do -- {{{ zk setup ===

  cmd [[packadd zk-nvim]]
  require 'zk'.setup {
    lsp = {
      auto_attach = {
        enabled = false
      }
    }
  }

end
-- }}}


-- ============================================================================
do -- {{{ treesitter setup ===

  -- Supported Languages
  -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages

  -- {{{ Add custom markdown parsers that support tags and wikilinks
  -- See: https://github.com/MDeiml/tree-sitter-markdown/issues/54#issuecomment-1646561140
  local parsers = require("nvim-treesitter.parsers").get_parser_configs()
  parsers.markdown = {
    install_info = {
      url = "/Users/dkJohFri/dev/projects/tree-sitter-markdown/tree-sitter-markdown",
      files = { "src/parser.c", "src/scanner.c" },
    },
    filetype = "markdown",
  }

  parsers.markdown_inline = {
    install_info = {
      url = "/Users/dkJohFri/dev/projects/tree-sitter-markdown/tree-sitter-markdown-inline",
      files = { "src/parser.c", "src/scanner.c" },
    },
    filetype = "markdown",
  }
  -- }}}

  local langs = {
    'lua',
    'markdown',
    'markdown_inline'
  }

  require 'nvim-treesitter.configs'.setup {
    ensure_installed = langs,
    highlight = {
      enable = true,
    },
    indent = {
      enable = true
    },
  }

end
-- }}}


-- ============================================================================
do -- {{{ paint setup ===

  -- cmd [[packadd paint.nvim]]
  -- require 'paint'.setup {
  --   highlights = {
  --     {
  --       filter = {
  --         filetype = 'markdown',
  --       },
  --       pattern = [[(:%d%d%d%d:)]],
  --       hl = 'Constant',
  --     },
  --   }
  -- }

end
-- }}}


-- ============================================================================
do -- {{{ disable unused built-in plugins ===
  -- g.loaded_gzip = true
  -- g.loaded_rrhelper = true
  -- g.loaded_tarPlugin = true
  -- g.loaded_zipPlugin = true
  -- g.loaded_netrwPlugin = true
  -- g.loaded_netrwFileHandlers = true
  -- g.loaded_netrwSettings = true
  -- g.loaded_2html_plugin = true
  -- g.loaded_vimballPlugin = true
  -- g.loaded_getscriptPlugin = true
  -- g.loaded_logipat = true
  -- g.loaded_tutor_mode_plugin = true
  -- g.loaded_matchit = true
end
-- }}}


-- vim: fdm=marker sw=2 ts=2 sts=2 et
