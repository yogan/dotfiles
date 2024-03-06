require("neo-tree").setup({
	window = {
		position = "current",
	},
	source_selector = {
		winbar = true,
		sources = {
			{
				source = "filesystem",
				display_name = " 󰉓 Files ",
			},
			{
				source = "git_status",
				display_name = " 󰊢 Git ",
			},
			{
				source = "buffers",
				display_name = " 󰈚 Buffers ",
			},
		},
	},
	filesystem = {
		filtered_items = {
			hide_dotfiles = false,
			hide_by_name = {
				"node_modules",
				".git",
			},
		},
		use_libuv_file_watcher = true,
	},
})

vim.keymap.set("n", "<leader>n", ":Neotree reveal<cr>", { desc = "Neotee: [n]eo files" })
vim.keymap.set("n", "<leader>b", ":Neotree buffers reveal<cr>", { desc = "Neotee: [b]uffers" })
vim.keymap.set("n", "<leader>c", ":Neotree git_status reveal<cr>", { desc = "Neotee: Git [c]hanges" })
