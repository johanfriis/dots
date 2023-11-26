local opt = vim.opt
local g = vim.g
local cmd = vim.cmd
local fn  = vim.fn
local autocmd = require('utils.functions').autocmd

-- ============================================================================
do -- {{{ general options setup ===

  opt.mouse        = 'a'                                        -- Enable mouse
  opt.mousescroll  = 'ver:1,hor:1'                              -- Customize mouse scroll
  opt.switchbuf    = 'uselast'                                  -- Use already opened buffers when switching
  opt.backup       = false                                      -- Don't store backup
  opt.writebackup  = false                                      -- Don't store backup

  opt.undodir      = fn.stdpath('state') .. '/undo'             -- Set directory for persistent undo
  opt.undofile     = true                                       -- Enable persistent undo

  opt.shadafile    = fn.stdpath('state') .. '/shada/main.shada' -- Set directory for 'shadafile'
  opt.shada        = [[!,'100,<50,s10,h,f1]]                    -- Add file marks to shadafile

  opt.timeout      = true                                       -- wait for timeout
  opt.timeoutlen   = 400                                        -- only wait for this long

  cmd [[filetype plugin indent on]]                             -- Enable all filetype plugins

end
-- }}}


-- ============================================================================
do -- {{{ customize netrw to fit my style ===

  g.netrw_liststyle    = 3
  g.netrw_browse_split = 0
  g.netrw_preview      = 1
  g.netrw_alto         = 0
  g.netrw_banner       = 0
  g.netrw_winsize      = 20

end
-- }}}


-- ============================================================================
do -- {{{ appearance options setup ===

  opt.laststatus = 2              -- Always show statusline

  -- mode | file [modified?] [readonly?]
  local left     = '%2{mode()} | %f %m %r'
  local center   = ''
  -- spell [lang] linenr,colnr percentage
  local right    = '%{&spelllang} %y %8(%l,%c%) %4p%%'
  opt.statusline = left .. ' %= ' .. center .. ' %= ' .. right

  -- Enable syntax highlighing if it wasn't already (as it is time consuming)
  if vim.fn.exists("syntax_on") ~= 1 then
    vim.cmd([[syntax enable]])
  end

  -- flash text on yank
  autocmd('Highlights', {
    TextYankPost = {
      callback = function() vim.highlight.on_yank() end,
    },
  })

  opt.showtabline   = 0           -- Never show tabline

  opt.cmdheight     = 0           -- Don't show commandline unless in use
  opt.showmode      = false       -- Don't show mode in command line
  opt.shortmess     = 'a' ..      -- Include a lot of abbreviations
                      'o' ..      -- Overwrite write / read messages
                      'O' ..      -- Overwrite reading message
                      'W' ..      -- Don't notify for write
                      'F' ..      -- Don't give file info while editing
                      'c' ..      -- Don't give |ins-completion-menu| messages
                      'I'         -- Don't show intro message

  opt.number        = true        -- Show line numbers
  opt.signcolumn    = 'yes'       -- Always show signcolumn or it would frequently shift

  opt.cursorline    = true        -- Enable highlighting of the current line
  opt.textwidth     = 80          -- Set the desired maximum textwidth
  -- opt.colorcolumn   = '+1'        -- Draw colored column one step to the right of desired maximum width

  opt.breakindent   = true        -- Indent wrapped lines to match line start
  opt.linebreak     = true        -- Wrap long lines at 'breakat' (if 'wrap' is set)
  opt.wrap          = false       -- Display long lines as just one line

  opt.splitbelow    = true        -- Horizontal splits will be below
  opt.splitright    = true        -- Vertical splits will be to the right


  opt.winblend      = 4           -- Make floating windows slightly transparent
  opt.pumblend      = 4           -- Make builtin completion menus slightly transparent
  opt.pumheight     = 10          -- Make popup menu smaller

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

  -- 'o' has a tendency to be reset to it's default, opening comments
  -- prevent 'o' from opening comments
  autocmd('FormatOptions', {
    FileType = {
      pattern = { '*' },
      command = [[setlocal formatoptions-=c formatoptions-=o]]
    },
  })

end
-- }}}

---- vim: foldmethod=marker ts=2 sts=2 sw=2 et
