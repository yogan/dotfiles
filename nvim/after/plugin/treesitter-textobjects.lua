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
		lsp_interop = {
			enable = true,
			border = "none",
			peek_definition_code = {
				["<leader>e"] = "@function.outer",
			},
		},
	},
})

local rep = require("nvim-treesitter.textobjects.repeatable_move")
local modes = { "n", "x", "o" }

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
wk.add({
	{ mode = modes, ";", rep.repeat_last_move_next, desc = "Repeat last movement (forward)" },
	{ mode = modes, ",", rep.repeat_last_move_previous, desc = "Repeat last movement (backward)" },
})

-- Make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set(modes, "f", rep.builtin_f_expr, { expr = true })
vim.keymap.set(modes, "F", rep.builtin_F_expr, { expr = true })
vim.keymap.set(modes, "t", rep.builtin_t_expr, { expr = true })
vim.keymap.set(modes, "T", rep.builtin_T_expr, { expr = true })

-- Make gitsigns.nvim movements repeatable with ; and , keys
local gs = require("gitsigns")
local next_hunk = function()
	gs.nav_hunk("next", { preview = false, target = "all" })
end
local prev_hunk = function()
	gs.nav_hunk("prev", { preview = false, target = "all" })
end
local next_hunk_preview = function()
	gs.nav_hunk("next", { preview = true, target = "all" })
end
local prev_hunk_preview = function()
	gs.nav_hunk("prev", { preview = true, target = "all" })
end
local next_hunk_rep, prev_hunk_rep = rep.make_repeatable_move_pair(next_hunk, prev_hunk)
local next_hunk_preview_rep, prev_hunk_preview_rep = rep.make_repeatable_move_pair(next_hunk_preview, prev_hunk_preview)
wk.add({
	{ mode = modes, "]h", next_hunk_rep, icon = "", desc = "Next Git change hunk" },
	{ mode = modes, "[h", prev_hunk_rep, icon = "", desc = "Previous Git change hunk" },
	{ mode = modes, "]H", next_hunk_preview_rep, icon = "", desc = "Next Git change hunk (preview)" },
	{ mode = modes, "[H", prev_hunk_preview_rep, icon = "", desc = "Previous Git change hunk (preview)" },
})

-- Make diagnostics (mostly LSP) movements repeatable with ; and , keys
local next_error = function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end
local prev_error = function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end
local next_diag_rep, prev_diag_rep = rep.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)
local next_error_rep, prev_error_rep = rep.make_repeatable_move_pair(next_error, prev_error)
wk.add({
	{ mode = modes, "]d", next_diag_rep, icon = "", desc = "Next diagnostic" },
	{ mode = modes, "[d", prev_diag_rep, icon = "", desc = "Previous diagnostic" },
	{ mode = modes, "]e", next_error_rep, icon = "", desc = "Next error" },
	{ mode = modes, "[e", prev_error_rep, icon = "", desc = "Previous error" },
})
