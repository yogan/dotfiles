local builtin = require("statuscol.builtin")

require("statuscol").setup({
	relculright = true,
	segments = {
		{
			sign = { namespace = { "gitsign" }, auto = true },
			click = "v:lua.ScSa",
		},
		{
			sign = { namespace = { "diagnostic*" }, auto = true },
			click = "v:lua.ScSa",
		},
		{
			text = { builtin.foldfunc, " " },
			condition = { true, builtin.not_empty },
			click = "v:lua.ScFa",
		},
		{
			text = { builtin.lnumfunc, " " },
			condition = { true, builtin.not_empty },
			click = "v:lua.ScLa",
		},
	},
})
