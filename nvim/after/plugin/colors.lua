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
			WhichKeyGroup = { "g_7", { italic = true } },
		},
		link = {
			MoreMsg = "AshenGreenLight",
			QuickFixLine = "MsgSeparator",
			TreesitterContext = "CursorLine",
		},
	},
})

vim.cmd("colorscheme ashen")

-- Putting this in hl.link doesn't work, even like this:
-- ["@markup.raw"] = "@markup.italic"
vim.cmd("highlight! link @markup.raw @markup.italic")
