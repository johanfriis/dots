local function map(mode, keybind, command, opts)
	opts = opts or {}
	vim.api.nvim_buf_set_keymap(0, mode, keybind, command,
		vim.tbl_extend('force', { noremap = true, silent = false }, opts))
end

-- open link under caret
map('n', '<CR>', '<CMD>lua vim.lsp.buf.definition()<CR>')

--
-- if require('zk.util').notebook_root(vim.fn.expand('%:p')) ~= nil then
-- 	local function map(mode, keybind, command, opts)
-- 		opts = opts or {}
-- 		vim.api.nvim_buf_set_keymap(0, mode, keybind, command,
-- 			vim.tbl_extend('force', { noremap = true, silent = false }, opts))
-- 	end
--
-- 	-- open link under caret
-- 	map('n', '<CR>', '<CMD>lua vim.lsp.buf.definition()<CR>')
--
-- 	-- create a new note with title
-- 	map('n', '<leader>nn', "<CMD>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
-- 		{ desc = "New Note" })
-- 	-- create a new note with selection as title
-- 	-- map('v', '<leader>nt', "<CMD>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>",
-- 	-- 	{ desc = "New Note with title from selection" })
-- 	-- create a new note with selection as content
-- 	-- map('v', '<leader>nt', "<CMD>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
-- 	-- 	{ desc = "New Note with content from selection" })
--
-- 	-- Show notes linking to current buffer
-- 	map('n', '<leader>nb', '<CMD>ZkBacklinks<CR>', { desc = "Note Backlinks" })
--
-- 	-- Show notes linked by the current buffer
-- 	map('n', '<leader>nl', '<CMD>ZkLinks<CR>', { desc = "Note Links" })
--
-- 	-- Open Code Actions for current
--
-- end
--
--
--
local nmap = function(keys, func, desc)
	if desc then
		desc = 'LSP: ' .. desc
	end

	vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end


-- 	-- open link under caret
-- 	map('n', '<CR>', '<CMD>lua vim.lsp.buf.definition()<CR>')
--
-- rename
vim.wo.conceallevel = 2

-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "markdown",
-- 	callback = function()
-- 		vim.wo.conceallevel = 2
-- 	end,
-- })
