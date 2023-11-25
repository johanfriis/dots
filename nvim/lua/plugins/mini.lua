return {
  -- {{{ mini.align
  {
    "echasnovski/mini.align",
    event = { "BufReadPre", "BufNewFile" },
    opts = true,
  },
  -- }}}

  -- {{{ mini.bracketed
  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    opts = true,
  },
  -- }}}

  -- {{{ mini.bufremove
  {
    "echasnovski/mini.bufremove",
    event = "VeryLazy",
    opts = true,
  },
  -- }}}

  -- {{{ mini.clue
  {
    "echasnovski/mini.clue",
    event = "BufReadPre",
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
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
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- mini.bracketed
          { mode = "n", keys = "[" },
          { mode = "n", keys = "]" },
          { mode = "x", keys = "[" },
          { mode = "x", keys = "]" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },
        window = {
          delay = 200,
          config = {
            width = "auto",
          },
        },
      })
    end,
  },
  -- }}}

  -- {{{ mini.comment
  {
    "echasnovski/mini.comment",
    event = "BufReadPre",
    opts = {},
  },
  -- }}}

  -- {{{ mini.extra
  {
    "echasnovski/mini.extra",
    event = "VeryLazy",
    opts = {},
  },
  -- }}}

  -- {{{ mini.files
  {
    "echasnovski/mini.files",
    event = "VeryLazy",
    config = function()
      local MiniFiles = require("mini.files")

      local show_dotfiles = false
      local filter_show = function(fs_entry)
        return true
      end
      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end

      local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        MiniFiles.refresh({ content = { filter = new_filter } })
      end

      local files_set_cwd = function(path)
        -- Works only if cursor is on the valid file system entry
        local cur_entry_path = MiniFiles.get_fs_entry().path
        local cur_directory = vim.fs.dirname(cur_entry_path)
        vim.fn.chdir(cur_directory)
        print("Updated CWD to " .. cur_directory)
      end

      local minifiles_toggle = function()
        if not MiniFiles.close() then
          MiniFiles.open(api.nvim_buf_get_name(0))
        end
      end

      augroup("MiniFilesUser", {
        User = {
          pattern = "MiniFilesBufferCreate",
          callback = function(args)
            map("n", "gr", files_set_cwd, { buffer = args.data.buf_id })
            map("n", "g.", toggle_dotfiles, { buffer = buf_id })
            map("n", "<CR>", MiniFiles.go_in, { buffer = args.data.buf_id })
            map("n", "<esc>", minifiles_toggle, { buffer = args.data.buf_id })
          end,
        },
      })

      MiniFiles.setup({
        content = {
          filter = filter_hide,
        },
      })
    end,
  },
  -- }}}

  -- {{{ mini.hipatterns
  {
    "echasnovski/mini.hipatterns",
    event = "VeryLazy",
    config = function()
      local hipatterns = require("mini.hipatterns")
      local MiniExtra = require("mini.extra")

      hipatterns.setup({
        highlighters = {
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

          hex_color = hipatterns.gen_highlighter.hex_color({
            style = "inline",
          }),
        },
      })
    end,
  },
  -- }}}

  -- {{{ mini.jump
  {
    "echasnovski/mini.jump",
    event = "BufReadPre",
    opts = {},
  },
  -- }}}

  -- {{{ mini.misc
  {
    "echasnovski/mini.misc",
    -- event = 'VeryLazy',
    lazy = false,
    config = function()
      local MiniMisc = require("mini.misc")
      MiniMisc.setup({
        make_global = { "put", "put_text" },
      })

      MiniMisc.setup_auto_root()
      MiniMisc.setup_restore_cursor()
    end,
  },
  -- }}}

  -- {{{ mini.move
  {
    "echasnovski/mini.move",
    event = "BufReadPre",
    opts = {},
  },
  -- }}}

  -- {{{ mini.pairs
  {
    "echasnovski/mini.pairs",
    event = "BufReadPre",
    opts = {
      modes = {
        insert = true,
        command = true,
        terminal = false,
      },
    },
  },
  -- }}}

  -- {{{ mini.sessions
  {
    "echasnovski/mini.sessions",
    event = "BufReadPre",
    opts = {
      autowrite = true,
      directory = vim.fn.stdpath("state") .. "/session",
      file = "",
    },
  },
  -- }}}

  -- {{{ mini.starter
  {
    "echasnovski/mini.starter",
    event = "VimEnter",
    opts = {
      footer = "",
    },
  },
  -- }}}

  -- {{{ mini.surround
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {},
  },
  -- }}}

  -- {{{ mini.tabline
  {
    "echasnovski/mini.tabline",
    event = "VeryLazy",
    opts = {},
  },
  -- }}}

  -- {{{ mini.trailspace
  {
    "echasnovski/mini.trailspace",
    event = "VeryLazy",
    opts = {},
  },
  -- }}}
}

-- vim: foldmethod=marker ts=2 sts=2 sw=2 et
