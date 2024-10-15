require("trouble").setup({ padding = false })

vim.keymap.set(
	"n",
	"<leader>xx",
	"<cmd>TroubleToggle<cr>",
	{ silent = true, noremap = true, desc = "Trouble: toggle diagnostics window" }
)
vim.keymap.set(
	"n",
	"<leader>xw",
	"<cmd>TroubleToggle workspace_diagnostics<cr>",
	{ silent = true, noremap = true, desc = "Trouble: workspace mode" }
)
vim.keymap.set(
	"n",
	"<leader>xd",
	"<cmd>TroubleToggle document_diagnostics<cr>",
	{ silent = true, noremap = true, desc = "Trouble: document mode" }
)
