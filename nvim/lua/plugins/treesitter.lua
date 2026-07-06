return {
	-- Treesitter parser manager.
	--
	-- Replaces the archived nvim-treesitter (archived 2026-04-03). Neovim 0.12
	-- ships treesitter in core (highlight, folding, indent, incremental
	-- selection) but has no parser installer; this plugin fills that gap and
	-- reuses nvim-treesitter's curated highlight queries.
	--
	-- Requires the `tree-sitter` CLI (a C compiler and git). On macOS the CLI
	-- lives in its own Homebrew formula, separate from the library:
	--   brew install tree-sitter-cli
	{
		"romus204/tree-sitter-manager.nvim",
		lazy = false,

		---@module "tree-sitter-manager"
		opts = {
			-- Parsers to install at startup. Neovim already bundles parsers +
			-- queries for c, lua, markdown, query, vim and vimdoc, so only the
			-- extras are listed here.
			ensure_installed = {
				"javascript",
				"python",
				"regex",
				"rust",
				"typescript",
			},

			-- Auto-install a parser the first time a new filetype is opened.
			auto_install = true,

			-- Don't auto-install the parsers Neovim already ships (so
			-- tree-sitter-manager doesn't shadow the bundled versions), plus
			-- gitcommit which we keep on legacy syntax.
			noauto_install = {
				"c",
				"lua",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"gitcommit",
			},

			-- Keep legacy `:h syntax` for gitcommit: its treesitter parser drops
			-- the diff red/green highlighting of the commit body.
			nohighlight = {
				"gitcommit",
			},
		},

		config = function(_, opts)
			require("tree-sitter-manager").setup(opts)

			-- Incremental selection is provided by Neovim core (0.12+): in visual
			-- mode `an`/`in` grow/shrink to the parent/child node, `]n`/`[n` move
			-- to the next/previous node and `]N`/`[N` expand to them. Falls back
			-- to `vim.lsp.buf.selection_range()` when no parser is available.
			--
			-- Map those to friendlier keys: meta-v starts the selection at the
			-- node under the cursor, `L`/`H` grow/shrink it.
			-- HINT: there is also `S` from `flash` to directly select a
			-- (arbitrary) node region around the cursor.
			vim.keymap.set("n", "<M-v>", "van", { remap = true, desc = "Select node" })
			vim.keymap.set("x", "L", "an", { remap = true, desc = "Grow node selection" })
			vim.keymap.set("x", "H", "in", { remap = true, desc = "Shrink node selection" })
		end,
	},

	-- AST based text objects
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = {
			"folke/snacks.nvim",
			"folke/which-key.nvim",
			"lewis6991/gitsigns.nvim",
			"romus204/tree-sitter-manager.nvim",
		},

		config = function()
			local gs = require("gitsigns")
			local sw = require("snacks.words")
			local wk = require("which-key")
			local modes = { "n", "x", "o" }

			-- Text objects have no built-in keymap option; select/move are wired
			-- up manually via the module functions further down.
			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Automatically jump forward to the text object.
					lookahead = true,
				},
				move = {
					-- Whether to set jumps in the jumplist.
					set_jumps = true,
				},
			})

			local ts_select = require("nvim-treesitter-textobjects.select")
			local ts_move = require("nvim-treesitter-textobjects.move")

			-- Select text objects. All of these can be combined with v, c, d,
			-- etc., so e.g. cia will change the current parameter (both type and
			-- name) (vaa will include a neighboring comma).
			local function select_map(key, query, desc)
				vim.keymap.set(
					{ "x", "o" },
					key,
					function() ts_select.select_textobject(query, "textobjects") end,
					{ desc = desc }
				)
			end
			select_map("ac", "@class.outer", "Select outer class")
			select_map("ic", "@class.inner", "Select inner class")
			select_map("af", "@function.outer", "Select outer function")
			select_map("if", "@function.inner", "Select inner function")
			select_map("aa", "@parameter.outer", "Select outer argument")
			select_map("ia", "@parameter.inner", "Select inner argument")
			select_map("al", "@loop.outer", "Select outer loop")
			select_map("il", "@loop.inner", "Select inner loop")
			select_map("a/", "@comment.outer", "Select outer comment")

			-- Move between text objects. The moves are made repeatable with
			-- `;`/`,` below (flash.nvim yields those keys for this on purpose).
			local function move_map(key, fn, query, desc)
				vim.keymap.set(modes, key, function() fn(query, "textobjects") end, { desc = desc })
			end
			move_map("]m", ts_move.goto_next_start, "@function.outer", "Next function start")
			move_map("]c", ts_move.goto_next_start, "@class.outer", "Next class start")
			move_map("]M", ts_move.goto_next_end, "@function.outer", "Next function end")
			move_map("]C", ts_move.goto_next_end, "@class.outer", "Next class end")
			move_map("[m", ts_move.goto_previous_start, "@function.outer", "Previous function start")
			move_map("[c", ts_move.goto_previous_start, "@class.outer", "Previous class start")
			move_map("[M", ts_move.goto_previous_end, "@function.outer", "Previous function end")
			move_map("[C", ts_move.goto_previous_end, "@class.outer", "Previous class end")

			-- Make the moves above repeatable: `;` repeats the last textobject
			-- move forward, `,` backward (regardless of the original direction).
			-- Also route the built-in `f`/`F`/`t`/`T` through the same machinery
			-- so `;`/`,` repeat those too ("all kinds of motions").
			local ts_repeat = require("nvim-treesitter-textobjects.repeatable_move")
			vim.keymap.set(modes, ";", ts_repeat.repeat_last_move_next, { desc = "Repeat last move forward" })
			vim.keymap.set(modes, ",", ts_repeat.repeat_last_move_previous, { desc = "Repeat last move backward" })
			vim.keymap.set(modes, "f", ts_repeat.builtin_f_expr, { expr = true })
			vim.keymap.set(modes, "F", ts_repeat.builtin_F_expr, { expr = true })
			vim.keymap.set(modes, "t", ts_repeat.builtin_t_expr, { expr = true })
			vim.keymap.set(modes, "T", ts_repeat.builtin_T_expr, { expr = true })

			-- Wrap a forward/backward move pair so it plugs into the same
			-- repeat machinery: `;` replays the last one forward, `,` backward.
			-- Returns the two directional functions ready to be mapped.
			local function repeatable_pair(forward_fn, backward_fn)
				local move = ts_repeat.make_repeatable_move(function(opts)
					if opts.forward then
						forward_fn()
					else
						backward_fn()
					end
				end)
				return function() move({ forward = true }) end, function() move({ forward = false }) end
			end

			-- Move between Git change hunks
			local function nav_hunk(dir, preview)
				---@diagnostic disable-next-line: missing-fields
				gs.nav_hunk(dir, { preview = preview, target = "all" })
			end
			local next_hunk, prev_hunk = repeatable_pair(
				function() nav_hunk("next", false) end,
				function() nav_hunk("prev", false) end
			)
			local next_hunk_preview, prev_hunk_preview = repeatable_pair(
				function() nav_hunk("next", true) end,
				function() nav_hunk("prev", true) end
			)
			wk.add({
				{ mode = modes, "]h", next_hunk, icon = "", desc = "Next Git change hunk" },
				{ mode = modes, "[h", prev_hunk, icon = "", desc = "Previous Git change hunk" },
				{ mode = modes, "]H", next_hunk_preview, icon = "", desc = "Next Git change hunk (preview)" },
				{
					mode = modes,
					"[H",
					prev_hunk_preview,
					icon = "",
					desc = "Previous Git change hunk (preview)",
				},
			})

			-- Move between diagnostics
			local next_diag, prev_diag = repeatable_pair(
				function() vim.diagnostic.jump({ count = 1 }) end,
				function() vim.diagnostic.jump({ count = -1 }) end
			)
			local next_error, prev_error = repeatable_pair(
				function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end,
				function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end
			)
			wk.add({
				-- stylua: ignore start
				{ mode = modes, "]d", next_diag, icon = { icon = "", color = "yellow" }, desc = "Next diagnostic" },
				{ mode = modes, "[d", prev_diag, icon = { icon = "", color = "yellow" }, desc = "Previous diagnostic" },
				{ mode = modes, "]e", next_error, icon = "", desc = "Next error" },
				{ mode = modes, "[e", prev_error, icon = "", desc = "Previous error" },
				-- stylua: ignore end
			})

			-- Snacks word LSP reference movements
			local next_word, prev_word = repeatable_pair(
				function() sw.jump(vim.v.count1, true) end,
				function() sw.jump(-vim.v.count1, true) end
			)
			wk.add({
				{ mode = modes, "]w", next_word, icon = "", desc = "Next word" },
				{ mode = modes, "[w", prev_word, icon = "", desc = "Previous word" },
			})

			-- Next/previous spelling error
			local next_spelling_error, prev_spelling_error = repeatable_pair(
				function() vim.cmd("normal! ]s") end,
				function() vim.cmd("normal! [s") end
			)
			wk.add({
				{ mode = modes, "]s", next_spelling_error, icon = "󰓆", desc = "Next spelling error" },
				{ mode = modes, "[s", prev_spelling_error, icon = "󰓆", desc = "Previous spelling error" },
			})
		end,
	},

	-- Keep context line at the top of the window
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = {
			"folke/which-key.nvim",
			"romus204/tree-sitter-manager.nvim",
		},
		opts = {
			max_lines = 8,
			multiline_threshold = 3,
		},
		config = function(_, opts)
			local tc = require("treesitter-context")
			local wk = require("which-key")

			tc.setup(opts)

			wk.add({
				{
					mode = "n",
					"[a",
					function() tc.go_to_context(vim.v.count1) end,
					desc = "Go to outer context (at level <count>)",
					icon = "",
				},
			})
		end,
	},

	-- Navigate between and move around AST nodes
	{
		"aaronik/treewalker.nvim",

		opts = {
			-- Whether to briefly highlight the node after jumping to it
			highlight = true,

			-- How long should above highlight last (in ms)
			highlight_duration = 250,

			-- The color of the above highlight. Must be a valid vim highlight group.
			-- (see :h highlight-group for options)
			highlight_group = "CursorLine",

			-- Whether to create a visual selection after a movement to a node.
			-- If true, highlight is disabled and a visual selection is made in
			-- its place.
			select = false,
		},

		config = function(_, opts)
			require("treewalker").setup(opts)

			-- movement
			vim.keymap.set({ "n", "v" }, "<M-k>", "<cmd>Treewalker Up<cr>", { silent = true })
			vim.keymap.set({ "n", "v" }, "<M-j>", "<cmd>Treewalker Down<cr>", { silent = true })
			vim.keymap.set({ "n", "v" }, "<M-h>", "<cmd>Treewalker Left<cr>", { silent = true })
			vim.keymap.set({ "n", "v" }, "<M-l>", "<cmd>Treewalker Right<cr>", { silent = true })

			-- swapping
			vim.keymap.set("n", "<M-S-k>", "<cmd>Treewalker SwapUp<cr>", { silent = true })
			vim.keymap.set("n", "<M-S-j>", "<cmd>Treewalker SwapDown<cr>", { silent = true })
			vim.keymap.set("n", "<M-S-h>", "<cmd>Treewalker SwapLeft<cr>", { silent = true })
			vim.keymap.set("n", "<M-S-l>", "<cmd>Treewalker SwapRight<cr>", { silent = true })
		end,
	},
}
