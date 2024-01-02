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
		vim.o.number = false
		vim.o.relativenumber = false
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
