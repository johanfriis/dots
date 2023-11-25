-- Initialize global object to store custom objects
_G.G = {}

-- {{{ SETTINGS
--     Borrowed heavily from author of mini.nvim plugins
--     https://github.com/echasnovski/nvim/blob/master/lua/ec/settings.lua

-- Leader key =================================================================
vim.g.mapleader = ' '

-- General ====================================================================
vim.o.mouse        = 'a'            -- Enable mouse
vim.o.mousescroll  = 'ver:25,hor:6' -- Customize mouse scroll
vim.o.switchbuf    = 'usetab'       -- Use already opened buffers when switching
vim.o.backup       = false          -- Don't store backup
vim.o.writebackup  = false          -- Don't store backup

vim.o.undodir  = vim.fn.stdpath('state') .. '/undo' -- Set directory for persistent undo
vim.o.undofile = true                                        -- Enable persistent undo

vim.o.shadafile = vim.fn.stdpath('state') .. '/shada' -- Set directory for 'shadafile'
vim.o.shada     = [[!,'100,<50,s10,h,f1]]              -- Add file marks to shadafile


vim.o.timeout    = true     -- wait for timeout
vim.o.timeoutlen = 200      -- only wait for this long

vim.cmd('filetype plugin indent on') -- Enable all filetype plugins

-- UI =========================================================================
vim.o.number        = true     -- Show line numbers
vim.o.laststatus    = 2        -- Always show statusline
vim.o.cursorline    = true     -- Enable highlighting of the current line
vim.o.colorcolumn   = '+1'     -- Draw colored column one step to the right of desired maximum width
vim.o.breakindent   = true     -- Indent wrapped lines to match line start
vim.o.linebreak     = true     -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.o.ruler         = false    -- Don't show cursor position
vim.o.shortmess     = 'aoOWFc' -- Disable certain messages from |ins-completion-menu|
vim.o.showmode      = false    -- Don't show mode in command line
vim.o.showtabline   = 2        -- Always show tabline
vim.o.signcolumn    = 'yes'    -- Always show signcolumn or it would frequently shift
vim.o.splitbelow    = true     -- Horizontal splits will be below
vim.o.splitright    = true     -- Vertical splits will be to the right
vim.o.termguicolors = true     -- Enable gui colors
vim.o.winblend      = 4        -- Make floating windows slightly transparent
vim.o.wrap          = false    -- Display long lines as just one line

vim.o.pumblend      = 10       -- Make builtin completion menus slightly transparent
vim.o.pumheight     = 10       -- Make popup menu smaller

vim.o.fillchars = table.concat(
  { 'eob: ', 'fold:╌', 'horiz:═', 'horizdown:╦', 'horizup:╩', 'vert:║', 'verthoriz:╬', 'vertleft:╣', 'vertright:╠' },
  ','
)

-- Colors =====================================================================
-- Enable syntax highlighing if it wasn't already (as it is time consuming)
-- Don't defer it because it affects start screen appearance
if vim.fn.exists("syntax_on") ~= 1 then
  vim.cmd([[syntax enable]])
end

-- Editing ====================================================================
vim.o.shiftwidth    = 2         -- Use this number of spaces for indentation
vim.o.tabstop       = 2         -- Insert 2 spaces for a tab
vim.o.expandtab     = true      -- Convert tabs to spaces
vim.o.autoindent    = true      -- Use auto indent
vim.o.smartindent   = true      -- Make indenting smart
vim.o.ignorecase    = true      -- Ignore case when searching (use `\C` to force not doing that)
vim.o.infercase     = true      -- Infer letter cases for a richer built-in keyword completion
vim.o.smartcase     = true      -- Don't ignore case when searching if pattern has upper case
vim.o.incsearch     = true      -- Show search results while typing
vim.o.virtualedit   = 'block'   -- Allow going past the end of line in visual block mode
vim.o.formatoptions = 'rqnl1jp' -- Improve comment editing

vim.opt.iskeyword:append('-')   -- Treat dash and underscore separated words as a word text object

-- Define pattern for a start of 'numbered' list. This is responsible for
-- correct formatting of lists when using `gw`. This basically reads as 'at
-- least one special character (digit, -, +, *) possibly followed some
-- punctuation (. or `)`) followed by at least one space is a start of list
-- item'
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

vim.o.completeopt = 'menuone,noinsert,noselect' -- Customize completions
vim.opt.complete:remove('t')                    -- Don't use tags for completion

-- Custom autocommands ========================================================
-- stylua: ignore start
vim.cmd([[augroup CustomSettings]])
  vim.cmd([[autocmd!]])

  -- Don't auto-wrap comments and don't insert comment leader after hitting 'o'
  -- If don't do this on `FileType`, this keeps magically reappearing.
  vim.cmd([[autocmd FileType * setlocal formatoptions-=c formatoptions-=o]])
vim.cmd([[augroup END]])
-- stylua: ignore start
-- }}}

-- {{{ FUNCTIONS

-- Create `<Leader>` mappings
G.leader = function(mode, suffix, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, '<Leader>' .. suffix, rhs, opts)
end

-- Create scratch buffer and focus on it
G.new_scratch_buffer = function()
  local buf_id = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_win_set_buf(0, buf_id)
  return buf_id
end

-- Toggle quickfix window
G.toggle_quickfix = function()
  local quickfix_wins = vim.tbl_filter(
    function(win_id) return vim.fn.getwininfo(win_id)[1].quickfix == 1 end,
    vim.api.nvim_tabpage_list_wins(0)
  )

  local command = #quickfix_wins == 0 and 'copen' or 'cclose'
  vim.cmd(command)
end

G.toggle_colorscheme = function()
  set_dark_mode = function()
    vim.api.nvim_set_option("background", "dark")
    vim.cmd.colorscheme("rose-pine-moon")
  end
  set_light_mode = function()
    vim.api.nvim_set_option("background", "light")
    vim.cmd.colorscheme("rose-pine-dawn")
  end
  if vim.o.background == "dark" then
    set_light_mode()
  else
    set_dark_mode()
  end

end

G.minifiles_toggle = function()
  local MiniFiles = require('mini.files')
  if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0)) end
end

-- Make action for `<CR>` which respects completion and autopairs
--
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

-- Helper table
local H = {}

H.keys = {
  ['cr'] = vim.api.nvim_replace_termcodes('<CR>', true, true, true),
  ['ctrl-y'] = vim.api.nvim_replace_termcodes('<C-y>', true, true, true),
  ['ctrl-y_cr'] = vim.api.nvim_replace_termcodes('<C-y><CR>', true, true, true),
}
G.cr_action = function()
  if vim.fn.pumvisible() ~= 0 then
    local item_selected = vim.fn.complete_info()['selected'] ~= -1
    return item_selected and H.keys['ctrl-y'] or H.keys['ctrl-y_cr']
  else
    return require('mini.pairs').cr()
  end
end

-- Tabpage with lazygit
G.open_lazygit = function()
  vim.cmd('tabedit')
  vim.cmd('setlocal nonumber signcolumn=no')

  -- Unset vim environment variables to be able to call `vim` without errors
  -- Use custom `--git-dir` and `--work-tree` to be able to open inside
  -- symlinked submodules
  vim.fn.termopen('VIMRUNTIME= VIM= lazygit --git-dir=$(git rev-parse --git-dir) --work-tree=$(realpath .)', {
    on_exit = function()
      vim.cmd('silent! :checktime')
      vim.cmd('silent! :bw')
    end,
  })
  vim.cmd('startinsert')
  vim.b.minipairs_disable = true
end
-- }}}

-- {{{ MAPPINGS
--     Heavily inspired by:
--     https://github.com/echasnovski/nvim/blob/master/lua/ec/mappings.lua

-- Helper function
local default_opts = { noremap = true, silent = true, expr = false, nowait = false, script = false, unique = false }

local keymap = function(mode, keys, cmd, opts)
  local o = vim.tbl_deep_extend('force', default_opts, opts or {})
  vim.keymap.set(mode, keys, cmd, o)
end

-- NOTE: Most mappings come from 'mini.basics'
-- Disable `s` shortcut (use `cl` instead) for safer usage of 'mini.surround'
keymap('n', [[s]], [[<Nop>]])
keymap('x', [[s]], [[<Nop>]])

-- Move inside completion list with <TAB>
keymap('i', [[<Tab>]], [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
keymap('i', [[<S-Tab>]], [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

-- Better command history navigation
keymap('c', '<C-p>', '<Up>', { silent = false })
keymap('c', '<C-n>', '<Down>', { silent = false })
-- }}}

-- {{{ LEADER MAPPINGS
--     Borrowed heavily from:
--     https://github.com/echasnovski/nvim/blob/master/lua/ec/mappings-leader.lua

-- Create global tables with information about clue groups in certain modes
-- Structure of tables is made to be compatible with 'mini.clue'.
G.leader_group_clues = {
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

-- b is for 'buffer'
G.leader('n','ba', [[<Cmd>b#<CR>]],                                 'Alternate')
G.leader('n','bd', [[<Cmd>lua MiniBufremove.delete()<CR>]],         'Delete')
G.leader('n','bD', [[<Cmd>lua MiniBufremove.delete(0, true)<CR>]],  'Delete!')
G.leader('n','bs', [[<Cmd>lua G.new_scratch_buffer()<CR>]],         'Scratch')
G.leader('n','bw', [[<Cmd>lua MiniBufremove.wipeout()<CR>]],        'Wipeout')
G.leader('n','bW', [[<Cmd>lua MiniBufremove.wipeout(0, true)<CR>]], 'Wipeout!')

-- c is for 'code'

-- e is for 'explore'
G.leader('n', 'ed', [[<Cmd>lua MiniFiles.open()<CR>]],                             'Directory')
G.leader('n', 'ef', [[<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>]], 'File directory')
-- TODO maybe we don't want this one?
G.leader('n', 'el', [[<Cmd>lua MiniFiles.open('~/dev/notes/log')<CR>]],            'ZK Logs')
G.leader('n', 'eq', [[<Cmd>lua G.toggle_quickfix()<CR>]],                         'Quickfix')

-- f is for 'fuzzy find'
G.leader('n', 'f/', [[<Cmd>Pick history scope='/'<CR>]],                             '"/" history')
G.leader('n', 'f:', [[<Cmd>Pick history scope=':'<CR>]],                             '":" history')
G.leader('n', 'fa', [[<Cmd>Pick git_hunks scope='staged'<CR>]],                      'Added hunks (all)')
G.leader('n', 'fA', [[<Cmd>Pick git_hunks path='%' scope='staged'<CR>]],             'Added hunks (current)')
G.leader('n', 'fb', [[<Cmd>Pick buffers<CR>]],                                       'Open buffers')
G.leader('n', 'fc', [[<Cmd>Pick git_commits choose_type='show_patch'<CR>]],          'Commits')
G.leader('n', 'fC', [[<Cmd>Pick git_commits path='%' choose_type='show_patch'<CR>]], 'Buffer commits')
G.leader('n', 'fd', [[<Cmd>Pick diagnostic scope='all'<CR>]],                        'Diagnostic workspace')
G.leader('n', 'fD', [[<Cmd>Pick diagnostic scope='current'<CR>]],                    'Diagnostic buffer')
G.leader('n', 'ff', [[<Cmd>Pick files<CR>]],                                         'Files')
G.leader('n', 'fg', [[<Cmd>Pick grep_live<CR>]],                                     'Grep live')
G.leader('n', 'fG', [[<Cmd>Pick grep pattern='<cword>'<CR>]],                        'Grep current word')
G.leader('n', 'fh', [[<Cmd>Pick help<CR>]],                                          'Help tags')
G.leader('n', 'fH', [[<Cmd>Pick hl_groups<CR>]],                                     'Highlight groups')
G.leader('n', 'fl', [[<Cmd>Pick buf_lines scope='all'<CR>]],                         'Lines (all)')
G.leader('n', 'fL', [[<Cmd>Pick buf_lines scope='current'<CR>]],                     'Lines (current)')
G.leader('n', 'fm', [[<Cmd>Pick git_hunks<CR>]],                                     'Modified hunks (all)')
G.leader('n', 'fM', [[<Cmd>Pick git_hunks path='%'<CR>]],                            'Modified hunks (current)')
G.leader('n', 'fo', [[<Cmd>Pick oldfiles<CR>]],                                      'Old files')
G.leader('n', 'fO', [[<Cmd>Pick options<CR>]],                                       'Options')
G.leader('n', 'fr', [[<Cmd>Pick resume<CR>]],                                        'Resume')
G.leader('n', 'fR', [[<Cmd>Pick lsp scope='references'<CR>]],                        'References (LSP)')
G.leader('n', 'fs', [[<Cmd>Pick lsp scope='workspace_symbol'<CR>]],                  'Symbols workspace (LSP)')
G.leader('n', 'fS', [[<Cmd>Pick lsp scope='document_symbol'<CR>]],                   'Symbols buffer (LSP)')
-- TODO add a picker for TODO / FIXME / etc ...

-- g is for git
G.leader('n', 'gA', [[<Cmd>lua require("gitsigns").stage_buffer()<CR>]],        'Add buffer')
G.leader('n', 'ga', [[<Cmd>lua require("gitsigns").stage_hunk()<CR>]],          'Add (stage) hunk')
G.leader('n', 'gb', [[<Cmd>lua require("gitsigns").blame_line()<CR>]],          'Blame line')
G.leader('n', 'gg', [[<Cmd>lua G.open_lazygit()<CR>]],                          'Git tab')
G.leader('n', 'gp', [[<Cmd>lua require("gitsigns").preview_hunk()<CR>]],        'Preview hunk')
G.leader('n', 'gq', [[<Cmd>lua require("gitsigns").setqflist()<CR>:copen<CR>]], 'Quickfix hunks')
G.leader('n', 'gu', [[<Cmd>lua require("gitsigns").undo_stage_hunk()<CR>]],     'Undo stage hunk')
G.leader('n', 'gx', [[<Cmd>lua require("gitsigns").reset_hunk()<CR>]],          'Discard (reset) hunk')
G.leader('n', 'gX', [[<Cmd>lua require("gitsigns").reset_buffer()<CR>]],        'Discard (reset) buffer')

-- l is for 'LSP' (Language Server Protocol)
G.leader('n', 'la', [[<Cmd>lua vim.lsp.buf.signature_help()<CR>]], 'Arguments popup')
G.leader('n', 'ld', [[<Cmd>lua vim.diagnostic.open_float()<CR>]],  'Diagnostics popup')
G.leader('n', 'lf', [[<Cmd>lua vim.lsp.buf.formatting()<CR>]],     'Format')
G.leader('n', 'li', [[<Cmd>lua vim.lsp.buf.hover()<CR>]],          'Information')
G.leader('n', 'lj', [[<Cmd>lua vim.diagnostic.goto_next()<CR>]],   'Next diagnostic')
G.leader('n', 'lk', [[<Cmd>lua vim.diagnostic.goto_prev()<CR>]],   'Prev diagnostic')
G.leader('n', 'lR', [[<Cmd>lua vim.lsp.buf.references()<CR>]],     'References')
G.leader('n', 'lr', [[<Cmd>lua vim.lsp.buf.rename()<CR>]],         'Rename')
G.leader('n', 'ls', [[<Cmd>lua vim.lsp.buf.definition()<CR>]],     'Source definition')

G.leader('x', 'lf', [[<Cmd>lua vim.lsp.buf.format()<CR><Esc>]],   'Format selection')

-- t is for [T]oggle
-- Stop highlighting of search results. NOTE: this can be done with default
-- `<C-l>` but this solution deliberately uses `:` instead of `<Cmd>` to go
-- into Command mode and back which updates 'mini.map'.
G.leader('n', 'th', ':let v:hlsearch = 1 - v:hlsearch<CR>', 'Toggle hlsearch')
G.leader('n', 'tu', G.toggle_colorscheme, 'Toggle colourscheme')
-- }}}

-- {{{ PACKAGES

-- {{{ Install package manager
--     https://github.com/folke/lazy.nvim
--     `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- }}}

require('lazy').setup({

  -- {{{ THEME - rose-pine-moon
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("rose-pine-moon")
    end,
  },
  -- }}}

  -- {{{ MINI - tiny treasures
  --     https://github.com/echasnovski/mini.nvim
  {
    'echasnovski/mini.sessions',
    version = false,
    opts = {
      autowrite = true,
      directory = vim.fn.stdpath('state') .. '/session',
      file = '',
    }
  },
  {
    'echasnovski/mini.starter',
    version = false,
    opts = {}
  },
  {
    'echasnovski/mini.statusline',
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    version = false,
    opts = {}
  },
  {
    'echasnovski/mini.tabline',
    version = false,
    opts = {
      show_icons = false
    }
  },
  {
    'echasnovski/mini.extra',
    version = false,
    opts = {}
  },
  {
    'echasnovski/mini.basics',
    version = false,
    config = function()
      require('mini.basics').setup({
        options = {
          -- Manage options manually
          basic = false,
        },
        mappings = {
          windows = false,
          move_with_alt = true,
          option_toggle_prefix = '<Leader>t',
        },
        autocommands = {
          basic = true,
          relnum_in_visual_mode = false,
        },
      })
    end,
  },
  {
    'echasnovski/mini.bracketed',
    version = false,
    opts = {}
  },
  {
    'echasnovski/mini.bufremove',
    version = false,
    opts = {}
  },
  {
    'echasnovski/mini.clue',
    version = false,
    config = function()
      local miniclue = require('mini.clue')
      miniclue.setup({
        clues = {
          G.leader_group_clues,
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
          delay = vim.o.timeoutlen,
          config = {
            width = 'auto',
            border = 'double'
          }
        },
      })
      -- Enable triggers in help buffer
      local clue_group = vim.api.nvim_create_augroup('g-miniclue', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'help',
        group = clue_group,
        callback = function(data) MiniClue.enable_buf_triggers(data.buf) end,
      })
    end,
  },
  {
    'echasnovski/mini.comment',
    version = false,
    opts = {}
  },
  {
    'echasnovski/mini.completion',
    version = false,
    opts = {
      lsp_completion = {
        source_func = 'omnifunc',
        auto_setup = false,
        process_items = function(items, base)
          -- Don't show Text and Snippet items
          items = vim.tbl_filter(function(x) return x.kind ~= 1 and x.kind ~= 15 end, items)
          return MiniCompletion.default_process_items(items, base)
        end
      },
      window = {
        info = { border = 'double' },
        signature = { border = 'double' },
      },
    }
  },
  {
    'echasnovski/mini.cursorword',
    version = false,
    opts = {}
  },
  {
    'echasnovski/mini.files',
    version = false,
    config = function()
      local MiniFiles = require('mini.files')

      local files_set_cwd = function(path)
        -- Works only if cursor is on the valid file system entry
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        vim.fn.chdir(cur_directory)
        print("Updated CWD to " .. cur_directory)
      end

      local show_dotfiles = false

      local filter_show = function(fs_entry) return true end

      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, '.')
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        MiniFiles.refresh({ content = { filter = new_filter } })
      end

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          vim.keymap.set('n', 'gr', files_set_cwd, { buffer = args.data.buf_id })
          vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id })
          vim.keymap.set('n', '<CR>', MiniFiles.go_in, { buffer = args.data.buf_id })
          vim.keymap.set('n', '<esc>', G.minifiles_toggle, { buffer = args.data.buf_id })
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesWindowOpen',
        callback = function(args)
          local win_id = args.data.win_id

          -- Customize window-local settings
          vim.wo[win_id].winblend = 4
          vim.api.nvim_win_set_config(win_id, { border = 'double' })
        end,
      })

      MiniFiles.setup({ 
        content = {
          filter = filter_hide
        }
      })
    end,
  },
  {
    'echasnovski/mini.hipatterns',
    version = false,
    config = function()
      local hipatterns = require('mini.hipatterns')
      local MiniExtra = require('mini.extra')

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
        },
      })
    end,
  },
  {
    'echasnovski/mini.indentscope',
    version = false,
    opts = true,
  },
  {
    'echasnovski/mini.jump',
    version = false,
    opts = true,
  },
  {
    'echasnovski/mini.jump2d',
    version = false,
    config = function()
      require('mini.jump2d').setup({
        labels = 'fjdksla;ghcnrueiwo',
      })

      vim.api.nvim_set_hl(0, 'MiniJump2dSpot', { fg = '#eb6f92', bg = '#232136' })
    end
  },
  {
    'echasnovski/mini.misc',
    version = false,
    config = function()
      require('mini.misc').setup({
        make_global = { 'put', 'put_text' }
      })
      MiniMisc.setup_auto_root()
      MiniMisc.setup_restore_cursor()
    end
  },
  {
    'echasnovski/mini.move',
    version = false,
    opts = true
  },
  {
    'echasnovski/mini.pairs',
    version = false,
    config = function()
      require('mini.pairs').setup({
        modes = {
          insert = true,
          command = true,
          terminal = false,
        }
      })

      vim.keymap.set('i', '<CR>', 'v:lua.G.cr_action()', { expr = true })
    end
  },
  {
    'echasnovski/mini.pick',
    version = false,
    config = function()
      require('mini.pick').setup({
        window = {
          config = {
            border = 'double'
          },
        },
      })
      vim.ui.select = MiniPick.ui_select
      vim.keymap.set('n', ',', [[<Cmd>Pick buf_lines scope='current'<CR>]], { nowait = true })
      vim.api.nvim_set_hl(0, 'MiniPickMatchCurrent', { fg = '#eb6f92', bg = '#232136' })
    end
  },
  {
    'echasnovski/mini.surround',
    version = false,
    opts = {
      search_method = 'cover_or_next'
    }
  },
  {
    'echasnovski/mini.trailspace',
    version = false,
    opts = true,
  },
  -- }}}

  -- {{{ TREESITTER
  --     https://github.com/nvim-treesitter/nvim-treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = {
          "lua",
          "elixir",
          "eex",
          "heex",
          "surface",
          "javascript",
          "typescript",
          "html",
          "css",
          "json",
          "yaml",
          "toml",
          "markdown",
          "bash",
          "fish",
          "comment",
          "git_config",
          "gitcommit",
          "gitignore",
          "dockerfile",

        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { 'markdown' }
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-k>",
            node_incremental = "<c-k>",
            scope_incremental = "<c-k>",
            node_decremental = "<M-space>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>csa"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>csA"] = "@parameter.inner",
            },
          },
        },
      })
    end
  },
  -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  -- https://github.com/nvim-treesitter/nvim-treesitter-context
  {
    "nvim-treesitter/nvim-treesitter-context",
    enable = false,
  },
  -- }}}

  -- {{{ VIM-MATCHUP
  -- https://github.com/andymass/vim-matchup/
  {
    "andymass/vim-matchup"
  },
  -- }}}

  -- {{{ TMUX
  --     https://github.com/aserowy/tmux.nvim
  {
    "aserowy/tmux.nvim",
    opts = {
      resize = {
        enable_default_keybindings = false,
      }
    },
  },
  -- }}}

  -- {{{ LSP
  -- { "folke/neodev.nvim", opts = true },
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      -- { "folke/neodev.nvim" },
      -- { 'hrsh7th/cmp-nvim-lsp' },
      -- { 'VonHeikemen/lsp-zero.nvim' },
    },
    config = function()
      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.MiniCompletion.completefunc_lsp')

        -- Currently all formatting is handled with 'null-ls' plugin
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false

        local diagnostic_opts = {
          float = { border = 'double' },
          signs = {
            priority = 9999,
            severity = { min = 'WARN', max = 'ERROR' },
          },
          virtual_text = { severity = { min = 'ERROR', max = 'ERROR' } },
          update_in_insert = false,
        }

        vim.diagnostic.config(diagnostic_opts)
      end

      local lspconfig = require("lspconfig")
      -- local configs = require("lspconfig.configs")

      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              -- Get the language server to recognize common globals
              globals = { 'vim' },
              disable = { 'need-check-nil' },
              workspaceDelay = -1,
            },

          }
        }
      })











      -- local lsp_zero = require('lsp-zero')
      -- lsp_zero.extend_lspconfig()
      --
      -- lsp_zero.on_attach(function(client, bufnr)
      --   -- see :help lsp-zero-keybindings
      --   -- to learn the available actions
      --   lsp_zero.default_keymaps({ buffer = bufnr })
      --
      --   vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = '[R]ename', buffer = bufnr })
      --   vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction', buffer = bufnr })
      -- end)
      --
      -- local lspconfig = require("lspconfig")
      -- local configs = require("lspconfig.configs")
      --
      -- -- LUA
      -- local lua_opts = lsp_zero.nvim_lua_ls()
      -- lspconfig.lua_ls.setup(lua_opts)
      --
      -- -- MARKDOWN
      -- lspconfig.marksman.setup({})
      --
      -- -- ELIXIR / LEXICAL
      -- -- https://github.com/lexical-lsp/lexical
      -- if not configs.lexical then
      --   configs.lexical = {
      --     default_config = {
      --       filetypes = { "elixir", "eelixir" },
      --       cmd = { "/Users/box/Code/tools/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
      --       root_dir = function(fname)
      --         return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
      --       end,
      --
      --     }
      --   }
      -- end
      -- lspconfig.lexical.setup({})
    end
  },


  -- }}}



})

-- }}}


do
  return
end



-- {{{ Setup map leader
--     This must happen before plugins are required
--     or the wrong leader will be used
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- }}}

-- {{{ Helper Functions
local function telescope_find_buffers()
  require("telescope.builtin").buffers(require("telescope.themes").get_dropdown({
    initial_mode = "normal",
    winblend = 0,
    previewer = false,
  }))
end

local function telescope_find_files()
  local builtin = require("telescope.builtin")

  vim.fn.system("git rev-parse --is-inside-work-tree")
  if vim.v.shell_error == 0 then
    builtin.git_files()
  else
    builtin.find_files()
  end
end

local minifiles_toggle = function()
  local MiniFiles = require('mini.files')
  if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0)) end
end

local files_set_cwd = function(path)
  local MiniFiles = require('mini.files')
  -- Works only if cursor is on the valid file system entry
  local cur_entry_path = MiniFiles.get_fs_entry().path
  local cur_directory = vim.fs.dirname(cur_entry_path)
  vim.fn.chdir(cur_directory)
  print("Updated CWD to " .. cur_directory)
end

vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    vim.keymap.set('n', 'gr', files_set_cwd, { buffer = args.data.buf_id })
    vim.keymap.set('n', '<esc>', minifiles_toggle, { buffer = args.data.buf_id })
  end,
})
-- }}}

-- {{{ Install and configure plugins
require("lazy").setup({

  -- {{{ WHICH-KEY
  --     https://github.com/folke/which-key.nvim
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      local wk = require("which-key")
      wk.register({
        f = { name = "[F]ind" },
        b = { name = "[B]uffer" },
        c = {
          name = "[C]ode",
          d = { name = "[D]iagnostic" },
          s = { name = "[S]wap" },
        },
        t = {
          name = "[T]ool",
          c = { name = "[C]hat" },
        },
        -- ["<leader>f"] = { name = "[F]ind" },
        -- ["<leader>b"] = { name = "[B]uffer" },
        -- ["<leader>d"] = { name = "[D]iagnostics" },
        -- ["<leader>c"] = { name = "[C]ode" },
        -- ["<leader>cd"] = { name = "[D]iagnostics" },
        -- ["<leader>cs"] = { name = "[S]wap" },
        -- ["<leader>tc"] = { name = "[C]hat" },
        -- ["<leader>t"] = { name = "[T]ool" },
      }, { prefix = "<leader>" })
    end,
  },
  -- }}}

  -- {{{ THEME - rose-pine-moon
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("rose-pine-moon")
    end,
  },
  -- }}}

  -- {{{ AUTO-DARK-MODE
  --     https://github.com/f-person/auto-dark-mode.nvim
  {
    "f-person/auto-dark-mode.nvim",
    -- enabled = false,
    lazy = false,
    priority = 10,
    config = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option("background", "dark")
        vim.cmd("colorscheme rose-pine-moon")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option("background", "light")
        vim.cmd("colorscheme rose-pine-dawn")
      end,
    },
  },
  -- }}}

  -- {{{ TELESCOPE
  --     https://github.com/nvim-telescope/telescope.nvim
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<esc>"] = "close",
            ["<C-u>"] = false,
            ["<C-d>"] = false,
          },
          n = {
            ["<esc>"] = "close",
            ["q"] = "close",
          },
        },
      },
    },
    keys = {
      { "<leader>o",  telescope_find_files,                             "n", desc = "[O]pen" },
      { "<leader>?",  "<cmd>Telescope help_tags<CR>",                   "n", desc = "Help" },
      { "<leader>bb", telescope_find_buffers,                           "n", desc = "[B]uffer" },
      { "<leader>ff", telescope_find_files,                             "n", desc = "[F]ind [F]iles" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",                   "n", desc = "[F]ind with [G]rep" },
      { "<leader>fd", "<cmd>Telescope diagnostics<CR>",                 "n", desc = "[F]ind [D]iagnostics" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>",                    "n", desc = "[F]ind [R]ecent Files" },
      { "<leader>fs", "<cmd>Telescope session-lens search_session<CR>", "n", desc = "[F]ind [S]ession" },
      { "gd",         "<cmd>Telescope lsp_definitions<cr>",             "n", desc = "[G]oto [D]efinition" },
      { "gr",         "<cmd>Telescope lsp_references<cr>",              "n", desc = "[G]oto [R]eference" },
    },
  },
  -- }}}

  -- {{{ RAINBOW DELIMITERS (DISABLED)
  --     https://github.com/hiphish/rainbow-delimiters.nvim
  {
    "hiphish/rainbow-delimiters.nvim",
    enabled = false
  },
  -- }}}

  -- {{{ AUTO-SESSION
  --     https://github.com/rmagatti/auto-session
  {
    'rmagatti/auto-session',
    config = function()
      require("telescope").load_extension("session-lens")
      require('auto-session').setup({
        log_level = "error",
        session_lens = {
          initial_mode = "normal",
          winblend = 0,
          previewer = false,
        }
      })
    end,
  },
  -- }}}

  -- {{{ TROUBLE
  --     https://github.com/folke/trouble.nvim
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>cdw", "<cmd>TroubleToggle workspace_diagnostics<CR>", "n", desc = "[W]orkspace Diagnostics" },
      { "<leader>cdd", "<cmd>TroubleToggle document_diagnostics<CR>",  "n", desc = "[D]ocument Diagnostics" },
      { "<leader>cdq", "<cmd>TroubleToggle quickfix<CR>",              "n", desc = "[Q]uickfix" },
      { "<leader>cdl", "<cmd>TroubleToggle loclist<CR>",               "n", desc = "[L]ocation List" },
    },
  },
  -- }}}

  -- {{{ LUALINE
  --     https://github.com/nvim-lualine/lualine.nvim
  {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = "rose-pine",
        component_separators = "|",
        section_separators = "",
      },
      -- extensions = {
      --   "neo-tree",
      -- },
    },
  },
  -- }}}

  -- {{{ COMMENT
  --     https://github.com/numToStr/Comment.nvim
  {
    "numToStr/Comment.nvim",
    opts = {},
  },
  -- }}}

  -- {{{ CONFORM
  --     https://github.com/stevearc/conform.nvim
  --     Lightweight yet powerful formatter plugin for Neovim
  {
    'stevearc/conform.nvim',
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      }
    },
  },
  -- }}}

  -- {{{ NEO-TREE
  --     https://github.com/nvim-neo-tree/neo-tree.nvim
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   branch = "v3.x",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-tree/nvim-web-devicons",
  --     "MunifTanjim/nui.nvim",
  --   },
  --   config = function()
  --     require("neo-tree").setup({
  --       close_if_last_window = false,
  --       enable_git_status = true,
  --       enable_diagnostics = true,
  --       window = {
  --         width = 40,
  --         mappings = {
  --           ["o"] = "open",
  --           ["u"] = "navigate_up",
  --         },
  --       },
  --       buffers = {
  --         follow_current_file = {
  --           enabled = true,
  --           leave_dirs_open = true,
  --         },
  --       },
  --       filesystem = {
  --         follow_current_file = {
  --           enabled = true,
  --           leave_dirs_open = true,
  --         },
  --         filtered_items = {
  --           hide_dotfiles = false,
  --           hide_gitignored = false,
  --           hide_by_name = {
  --             "node_modules"
  --           },
  --           never_show = {
  --             ".DS_Store",
  --             "thumbs.db"
  --           },
  --         },
  --       },
  --     })
  --
  --     vim.keymap.set('n', '<leader>e',
  --       ':Neotree action=focus source=filesystem position=left toggle=true reveal=true<cr>')
  --   end
  -- },
  -- }}}

  -- {{{ FERN
  --     https://github.com/lambdalisue/fern.vim
  --     https://github.com/lambdalisue/fern-hijack.vim
  --     https://github.com/lambdalisue/fern-git-status.vim
  --     https://github.com/lambdalisue/fern-mapping-project-top.vim
  {
    'lambdalisue/fern.vim',
    dependencies = {
      { 'lambdalisue/fern-hijack.vim' },
      { 'lambdalisue/fern-git-status.vim' },
      { "TheLeoP/fern-renderer-web-devicons.nvim" },
      { "lambdalisue/fern-mapping-project-top.vim" },
      -- { 'LumaKernel/fern-mapping-reload-all.vim' },
      -- { 'yuki-yano/fern-preview.vim' },
      -- { 'yuki-yano/fern-renderer-web-devicons.nvim' },
      -- { 'lambdalisue/glyph-palette.vim' },
    },
    lazy = true,
    cmd = { 'Fern' },
    config = function()
      vim.g['fern#renderer'] = 'nvim-web-devicons'

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('fern-startup', {}),
        pattern = { 'fern' },
        callback = function()
          local km = function(m, k, c)
            vim.keymap.set(m, k, c, { silent = true, buffer = true, noremap = true })
          end
          km('n', 'p', '<Plug>(fern-action-project-top:reveal)')
        end
      })
    end,
    keys = {
      { "<leader>fF", "<cmd>Fern . -reveal=%:p<CR>", "n", desc = "Show [F]ern" },
    }
  },
  {
    'lambdalisue/fern-hijack.vim',
    dependencies = {
      'lambdalisue/fern.vim',
      cmd = 'Fern',
    },
  },
  -- }}}

  -- {{{ MINI FILES
  --     https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-files.txt
  {
    'echasnovski/mini.files',
    version = false,
    opts = {
      windows = {
        preview = true
      }
    }
  },
  -- }}}

  -- {{{ CHAT-GPT
  --     https://github.com/jackMort/ChatGPT.nvim
  {
    "jackMort/ChatGPT.nvim",
    lazy = true,
    cmd = "ChatGPT",
    opts = {
      api_key_cmd = "op read op://Personal/openai.com/terminal -n",
      popup_input = {
        submit = "<C-m>",
      },
    },
    keys = {
      { "<leader>tcc", "<cmd>ChatGPT<CR>",                    { "n" },      desc = "Chat" },
      { "<leader>tce", "<cmd>ChatGPTEditWithInstruction<CR>", { "n", "v" }, desc = "Edit with instructions" },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  -- }}}

  -- {{{ ZK-NVIM
  --     https://github.com/mickael-menu/zk-nvim
  {
    "mickael-menu/zk-nvim",
    opts = {
      lsp = {
        auto_attach = {
          enabled = false
        }
      }
    },
    config = function()
      require("zk").setup({
        -- See Setup section below
      })
    end
  },
  -- }}}

  -- {{{ HEADLINES - MARKDOWN STYLING
  --     Horizontal highlights for text filetypes, like markdown
  --     https://github.com/lukas-reineke/headlines.nvim
  {
    "lukas-reineke/headlines.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = {
      markdown = {
        fat_headlines = false,
        headline_highlights = false,
      }
    }
  },
  -- }}}

  -- {{{ LSP & COMPLETION
  --     https://github.com/VonHeikemen/lsp-zero.nvim
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      -- Disable automatic setup, we are doing it manually
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },

  -- Autocompletion
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { 'L3MON4D3/LuaSnip' },
      { 'VonHeikemen/lsp-zero.nvim' },
    },
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_cmp()

      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()

      cmp.setup({
        sources = {
          { name = "copilot" },
          { name = "nvim_lsp" },
        },
        formatting = lsp_zero.cmp_format(),
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-f>'] = cmp_action.luasnip_jump_forward(),
          ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        })
      })
    end
  },

  -- LSP
  {
    'neovim/nvim-lspconfig',
    cmd = 'LspInfo',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { "folke/neodev.nvim" },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'VonHeikemen/lsp-zero.nvim' },
    },
    config = function()
      local lsp_zero = require('lsp-zero')
      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(client, bufnr)
        -- see :help lsp-zero-keybindings
        -- to learn the available actions
        lsp_zero.default_keymaps({ buffer = bufnr })

        vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { desc = '[R]ename', buffer = bufnr })
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction', buffer = bufnr })
      end)

      local lspconfig = require("lspconfig")
      local configs = require("lspconfig.configs")

      -- LUA
      local lua_opts = lsp_zero.nvim_lua_ls()
      lspconfig.lua_ls.setup(lua_opts)

      -- MARKDOWN
      lspconfig.marksman.setup({})

      -- ELIXIR / LEXICAL
      -- https://github.com/lexical-lsp/lexical
      if not configs.lexical then
        configs.lexical = {
          default_config = {
            filetypes = { "elixir", "eelixir" },
            cmd = { "/Users/box/Code/tools/lexical/_build/dev/package/lexical/bin/start_lexical.sh" },
            root_dir = function(fname)
              return lspconfig.util.root_pattern("mix.exs", ".git")(fname) or vim.loop.os_homedir()
            end,

          }
        }
      end
      lspconfig.lexical.setup({})
    end
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    }
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      "zbirenbaum/copilot.lua"
    },
    opts = {},
  },
  -- }}}

})
-- }}}

-- {{{ Configure Options
--     See `:help vim.o`

-- Automatically change directory to current file
-- 2023.11.15 - disable this since it messes with using telescope
-- vim.o.autochdir = true

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = "unnamedplus"

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Save most options to the session
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Don't wrap lines
vim.wo.wrap = false

-- Default indentation
vim.o.autoindent = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
-- }}}

-- {{{ Basic Keymaps
--     See `:help vim.keymap.set()`

-- Add sane indentiation commands
vim.keymap.set("v", ">", ">gv")
vim.keymap.set("v", "<", "<gv")

-- quickly list open buffers and nav files
vim.keymap.set("n", "<tab>", telescope_find_buffers)
vim.keymap.set("n", "§", minifiles_toggle)

-- easily close a buffer
vim.keymap.set("n", "<leader>bc", "<cmd>bd<CR>", { desc = "[C]lose" })

-- emulate some readline keybinds in command mode
vim.keymap.set('c', '<C-a>', '<Home>')
vim.keymap.set('c', '<C-e>', '<End>')
vim.keymap.set('c', '<C-b>', '<Left>')
vim.keymap.set('c', '<C-f>', '<Right>')

-- }}}
-- vim: foldmethod=marker ts=2 sts=2 sw=2 et
