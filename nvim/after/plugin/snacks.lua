require("snacks").setup({
	picker = {
		enabled = true,
		win = {
			input = {
				bo = {
					textwidth = 0,
				},
			},
			preview = {
				wo = {
					number = false,
					spell = false,
					wrap = false,
					statuscolumn = "",
					foldcolumn = "0",
				},
			},
		},
	},
	toggle = { enabled = true },
})

-- Files
vim.keymap.set("n", "<C-p>", function()
	Snacks.picker.smart({ hidden = true })
end, { desc = "Find files" })

-- Grep
vim.keymap.set("n", "<C-f>", function()
	Snacks.picker.grep()
end, { desc = "Grep" })
vim.keymap.set("n", "<C-g>", function()
	Snacks.picker.grep_buffers()
end, { desc = "Grep buffers" })
vim.keymap.set({ "n", "x" }, "<leader>*", function()
	Snacks.picker.grep_word()
end, { desc = "Live grep (word or selection)" })

-- Vim things: buffers, registers, etc.
vim.keymap.set("n", "<F1>", function()
	Snacks.picker.help()
end, { desc = "Help Pages" })
vim.keymap.set("n", "<C-b>", function()
	Snacks.picker.buffers()
end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>pr", function()
	Snacks.picker.registers()
end, { desc = "Registers" })
vim.keymap.set("n", "<leader>,", function()
	Snacks.picker.spelling()
end, { desc = "Spelling" })
