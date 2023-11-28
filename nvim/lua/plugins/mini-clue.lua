local clue = require('mini.clue')

local main_clues = {
  -- { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
  -- { mode = 'n', keys = '<Leader>c', desc = '+Code' },
  -- { mode = 'n', keys = '<Leader>e', desc = '+Explore' },
  -- { mode = 'n', keys = '<Leader>f', desc = '+Find' },
  { mode = 'n', keys = '<Leader>g', desc = '+Git' },
  { mode = 'n', keys = '<Leader>l', desc = '+LSP' },
  { mode = 'n', keys = '<Leader>n', desc = '+Notes' },
  { mode = 'n', keys = '<Leader>p', desc = '+Pick' },
  { mode = 'n', keys = '<Leader>t', desc = '+Toggle' },
}

clue.setup({
  clues = {
    main_clues,
    clue.gen_clues.builtin_completion(),
    clue.gen_clues.g(),
    clue.gen_clues.marks(),
    clue.gen_clues.registers(),
    clue.gen_clues.windows({ submode_resize = true }),
    clue.gen_clues.z(),
  },
  triggers = {
    -- Leader triggers
    { mode = "n", keys = "<Leader>" },
    { mode = "x", keys = "<Leader>" },

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
