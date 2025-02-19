require("catppuccin").setup({
	custom_highlights = function(colors)
		return {
			ColorColumn = { bg = "#1a1a2a" },
			Folded = { bg = colors.surface0 },
			UfoFoldedEllipsis = { fg = colors.lavender, bg = colors.surface0 },
		}
	end,
	dim_inactive = { enabled = true },
	show_end_of_buffer = true,
})

vim.api.nvim_set_hl(0, "ExtraWhitespace", { link = "DiagnosticVirtualTextError" })

vim.cmd("colorscheme catppuccin")
