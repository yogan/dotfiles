-- using this group for all autocmds here allows to re-source
-- this file without having to clear the autocmds first
local group = vim.api.nvim_create_augroup("yogan-autocmds", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "TelescopePrompt", "help" },
	desc = "Disable cursorline in TelescopePrompt and help",
	command = "setlocal nocursorline",
})

vim.api.nvim_create_autocmd("VimResized", {
	group = group,
	desc = "Resize windows when terminal size changes",
	command = "wincmd =",
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = group,
	desc = "Setup defaults for new terminal windows",
	callback = function()
		vim.opt.number = false
		vim.opt.relativenumber = false
		vim.cmd("DisableWhitespace")
		vim.cmd("startinsert")
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = group,
	desc = "Enable spell checking for text files",
	pattern = { "*.txt", "*.md", "*.tex" },
	command = "setlocal spell",
})

vim.api.nvim_create_autocmd("WinEnter", {
	group = group,
	desc = "Enable color column and cursor line for active window",
	pattern = "*",
	callback = function()
		vim.opt.colorcolumn = "+1,+20"
		vim.opt.cursorline = true
	end,
})

vim.api.nvim_create_autocmd("WinLeave", {
	group = group,
	desc = "Disable color column and cursor line for inactive windows",
	pattern = "*",
	callback = function()
		vim.opt.colorcolumn = "0"
		vim.opt.cursorline = false
	end,
})

-- Highlight when yanking text, see `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	desc = "Highlight when yanking (copying) text",
	callback = function()
		vim.highlight.on_yank()
	end,
})
