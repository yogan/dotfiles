---@diagnostic disable-next-line: missing-fields
require("trouble").setup({})

vim.keymap.set(
	"n",
	"<leader>xx",
	"<cmd>Trouble diagnostics toggle<cr>",
	{ silent = true, noremap = true, desc = "Trouble: diagnostics toggle" }
)
vim.keymap.set(
	"n",
	"<leader>xb",
	"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
	{ silent = true, noremap = true, desc = "Trouble: buffer diagnostics toggle" }
)
vim.keymap.set(
	"n",
	"<leader>xs",
	"<cmd>Trouble symbols toggle focus=false<cr>",
	{ silent = true, noremap = true, desc = "Trouble: symbols toggle" }
)
vim.keymap.set(
	"n",
	"<leader>xl",
	"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
	{ silent = true, noremap = true, desc = "Trouble: LSP definitions / references / …" }
)
