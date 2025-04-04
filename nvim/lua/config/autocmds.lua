-- using this group for all autocmds here allows to re-source
-- this file without having to clear the autocmds first
local group = vim.api.nvim_create_augroup("yogan-autocmds", { clear = true })

-- do not add comment leaders (like //)  after 'o' or 'O' (see :help fo-table)
-- (setting it statically in options.lua does not work, probably changed by some
-- LSP stuff)
vim.api.nvim_create_autocmd("BufEnter", {
	group = group,
	desc = "Do not add comment leaders after 'o' or 'O'",
	pattern = "*",
	command = "setlocal formatoptions-=o",
})

vim.api.nvim_create_autocmd("VimResized", {
	group = group,
	desc = "Resize windows when terminal size changes",
	command = "wincmd =",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	group = group,
	desc = "Enable spell checking for certain file types",
	pattern = {
		"*.js?",
		"*.lua",
		"*.md",
		"*.py",
		"*.tex",
		"*.ts?",
		"*.txt",
		"*.vim",
		"CHANGELOG",
		"README",
	},
	command = "setlocal spell",
})

local fully_ignore_fts = {
	"noice",
	"notify",
	"snacks_dashboard",
}

local no_cursorline_fts = {
	"NvimTree",
	"TelescopePrompt",
	"TelescopeResults",
	"WhichKey",
	"help",
}

local no_colorcolumn_fts = {
	"NvimTree",
	"TelescopePrompt",
	"TelescopeResults",
	"Trouble",
	"WhichKey",
	"help",
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
		-- "Yank" is custom and defined in `ui.lua`
		vim.highlight.on_yank({ higroup = "Yank", timeout = 200 })
	end,
})
