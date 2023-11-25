local config = function()
	local null = require("null-ls")

	local c = null.builtins.code_actions
	local d = null.builtins.diagnostics
	local f = null.builtins.formatting

	local sources = {
		c.refactoring,
		f.stylua.with({ filetypes = { "lua" } }),
	}

	null.setup({
		sources = sources,
		should_attach = function(bufnr)
			return true
		end,
	})
end

return {
	"nvimtools/none-ls.nvim",

	event = "BufReadPre",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = config,
}
