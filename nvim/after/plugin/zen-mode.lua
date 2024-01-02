require("zen-mode").setup({
	window = {
		height = 0.95,
		width = 120,
		options = {
			number = false, -- false = disable number column
			relativenumber = false, -- false = disable relative numbers
			list = false, -- false = disable whitespace characters
			colorcolumn = "0", -- disable color column
		},
	},
	plugins = {
		gitsigns = { enabled = true },
		tmux = { enabled = true },
		twilight = { enabled = true },
	},
})

vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Toggle Zen Mode" })
