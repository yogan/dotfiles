require("ashen").setup({
	style_presets = {
		italic_comments = true,
	},
	hl = {
		merge_override = {
			ColorColumn = { bg = "#111111" },
			EndOfBuffer = { fg = "#424242", bg = "#0c0c0c" },
			ExtraWhitespace = { bg = "#562727" },
			Folded = { bg = "#181818" },
		},
		link = {
			TreesitterContext = "CursorLine",
		},
	},
})

vim.cmd("colorscheme ashen")
