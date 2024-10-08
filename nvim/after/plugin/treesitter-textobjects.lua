---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- automatically jump forward to textobject
			keymaps = {
				-- All of those can be combine with v, c, d, etc., so e.g.
				-- cia will change the current parameter (both type and name)
				-- (vaa will include a neighboring comma)

				["ac"] = { query = "@class.outer", desc = "Select outer class" },
				["ic"] = { query = "@class.inner", desc = "Select inner class" },

				["af"] = { query = "@function.outer", desc = "Select outer function" },
				["if"] = { query = "@function.inner", desc = "Select inner function" },

				["aa"] = { query = "@parameter.outer", desc = "Select outer argument" },
				["ia"] = { query = "@parameter.inner", desc = "Select inner argument" },

				["al"] = { query = "@loop.outer", desc = "Select outer loop" },
				["il"] = { query = "@loop.inner", desc = "Select inner loop" },

				["a/"] = { query = "@comment.outer", desc = "Select outer comment" },
			},
		},
	},
})
