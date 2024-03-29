require("nightfox").setup({
	options = {
		transparent = false, -- Disable setting background
		dim_inactive = true, -- Non focused panes set to alternative background
		styles = {
			comments = "italic",
			-- keywords = "bold",
			-- functions = "italic",
			-- strings = "italic",
			-- variables = "italic",
		},
	},
	groups = {
		nightfox = {
			ColorColumn = { bg = "#18212d" },
			CursorLine = { bg = "bg2" },
			EndOfBuffer = { bg = "#141d27" },
			Folded = { bg = "#151c27" },
			UfoFoldedEllipsis = { fg = "#71839b" },
			LineNr = { fg = "bg4", bg = "bg0" },
			Substitute = { bg = "palette.yellow.dim" },
			NvimTreeSpecialFile = { fg = "palette.green.dim" },
		},
		duskfox = {
			ColorColumn = { bg = "#27243b" },
			EndOfBuffer = { bg = "#1b192a" },
		},
	},
})

-- Setting a dimmed red (taken from color scheme) as background for trailing
-- whitespace. Needs to be at the very end, any further call to 'colorscheme'
-- resets to the default full bright red. :-/
local spec = require("nightfox.spec").load("nightfox")
-- print(vim.inspect(spec.palette)) -- for finding stuff
vim.g.better_whitespace_guicolor = spec.palette.red.dim

vim.cmd("colorscheme duskfox")
