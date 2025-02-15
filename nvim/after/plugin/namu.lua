local namu = require("namu")
local ns = require("namu.namu_symbols")
local wk = require("which-key")

-- constants and variables are kind of essential, due to very common
-- const func = () => … stuff
local js_ts_kinds = {
	"Class",
	"Constant",
	"Enum",
	"Function",
	"Interface",
	"Method",
	"Module",
	"Variable",
}

namu.setup({
	namu_symbols = {
		enable = true,
		options = {
			AllowKinds = {
				default = {
					"Class",
					-- "Constant",
					-- "Constructor",
					-- "Enum",
					-- "EnumMember",
					-- "Event",
					-- "Field",
					"Function",
					"Interface",
					"Method",
					"Module",
					-- "Operator",
					-- "Package",
					-- "Property",
					-- "Struct",
					-- "Table",
					-- "TypeParameter",
					-- "Variable",
				},
				javascript = js_ts_kinds,
				javascriptreact = js_ts_kinds,
				typescript = js_ts_kinds,
				typescriptreact = js_ts_kinds,
			},
			movement = {
				next = "<C-n>",
				previous = "<C-p>",
				alternative_next = "<C-j>",
				alternative_previous = "<C-k>",
			},
		},
	},
})

wk.add({
	{ mode = "n", "<leader><leader>", ns.show, desc = "Namu LSP Symbols", icon = "" },
})
