-- using this group for all autocmds here allows to re-source
-- this file without having to clear the autocmds first
local group = vim.api.nvim_create_augroup("yogan-autocmds", { clear = true })

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

local fully_ignore_fts = {
	"noice",
	"notify",
}

local no_cursorline_fts = {
	"NvimTree",
	"TelescopePrompt",
	"TelescopeResults",
	"WhichKey",
	"help",
	"neo-tree",
}

local no_colorcolumn_fts = {
	"NvimTree",
	"TelescopePrompt",
	"TelescopeResults",
	"Trouble",
	"WhichKey",
	"alpha",
	"help",
	"neo-tree",
	"packer",
	"qf",
}

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	desc = "Disable color column and cursor line for certain filetypes",
	pattern = "*",
	callback = function()
		if vim.tbl_contains(fully_ignore_fts, vim.bo.filetype) then
			return
		end

		if vim.tbl_contains(no_cursorline_fts, vim.bo.filetype) then
			vim.opt_local.cursorline = false

		else
			vim.opt_local.cursorline = true
		end
		if vim.tbl_contains(no_colorcolumn_fts, vim.bo.filetype) then
			vim.opt_local.colorcolumn = "0"
		else
			vim.opt_local.colorcolumn = "+1,+20"
		end
	end,
})

vim.api.nvim_create_autocmd("WinEnter", {
	group = group,
	desc = "Enable color column and cursor line for active window",
	pattern = "*",
	callback = function()
		if vim.tbl_contains(fully_ignore_fts, vim.bo.filetype) then
			return
		end

		if not vim.tbl_contains(no_cursorline_fts, vim.bo.filetype) then
			vim.opt_local.cursorline = true
		end
		if not vim.tbl_contains(no_colorcolumn_fts, vim.bo.filetype) then
			vim.opt_local.colorcolumn = "+1,+20"
		end
	end,
})

vim.api.nvim_create_autocmd("WinLeave", {
	group = group,
	desc = "Disable color column and cursor line for inactive windows",
	pattern = "*",
	callback = function()
		if vim.tbl_contains(fully_ignore_fts, vim.bo.filetype) then
			return
		end

		vim.opt_local.cursorline = false
		vim.opt_local.colorcolumn = "0"
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
