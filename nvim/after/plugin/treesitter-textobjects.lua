local wk = require("which-key")

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
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = { query = "@function.outer", desc = "Next function start" },
				["]]"] = { query = "@class.outer", desc = "Next class start" },
			},
			goto_next_end = {
				["]M"] = { query = "@function.outer", desc = "Next function end" },
				["]["] = { query = "@class.outer", desc = "Next class end" },
			},
			goto_previous_start = {
				["[m"] = { query = "@function.outer", desc = "Previous function start" },
				["[["] = { query = "@class.outer", desc = "Previous class start" },
			},
			goto_previous_end = {
				["[M"] = { query = "@function.outer", desc = "Previous function end" },
				["[]"] = { query = "@class.outer", desc = "Previous class end" },
			},
		},
	},
})

local rep = require("nvim-treesitter.textobjects.repeatable_move")

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
wk.add({
	{ mode = { "n", "x", "o" }, ";", rep.repeat_last_move_next, desc = "Repeat last movement (forward)" },
	{ mode = { "n", "x", "o" }, ",", rep.repeat_last_move_previous, desc = "Repeat last movement (backward)" },
})

-- Make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", rep.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", rep.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", rep.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", rep.builtin_T_expr, { expr = true })

-- Make gitsigns.nvim movements repeatable with ; and , keys
local gs = require("gitsigns")
local next_hunk_repeat, prev_hunk_repeat = rep.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
wk.add({
	{ mode = { "n", "x", "o" }, "]h", next_hunk_repeat, icon = "", desc = "Next Git change hunk" },
	{ mode = { "n", "x", "o" }, "[h", prev_hunk_repeat, icon = "", desc = "Previous Git change hunk" },
})
