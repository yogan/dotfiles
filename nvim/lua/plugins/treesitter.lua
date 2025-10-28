return {
	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,

		-- NOTE for Windows: Treesitter requires a C compiler. This one works fine:
		-- https://github.com/skeeto/w64devkit (unzip somewhere, add bin/ to PATH)
		build = ":TSUpdate",

		-- see https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/treesitter.lua
		init = function(plugin)
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,

		---@class TSConfig
		opts = {
			-- A list of parser names, or 'all'
			ensure_installed = {
				"c",
				"javascript",
				"lua",
				"python",
				"regex",
				"rust",
				"typescript",
				"vim",
				"vimdoc",
			},

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			highlight = {
				-- Enable by default, but disable for some file types (where default
				-- highlighting looks better; e.g. gitcommit only has diff green/red
				-- highlighting without treesitter)
				enable = true,
				disable = { "gitcommit", "tmux" },

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},

			-- see https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#incremental-selection
			incremental_selection = {
				enable = true,
				keymaps = {
					-- Starting the selection with meta-v already starts with the
					-- current node selected and does not have the bug that when
					-- shrinking the selection it shrinks down to the last selection.
					-- This only happens when we entered visual mode normally and then
					-- use `L` and `H` to grow and shrink the selection, but it should
					-- usually not be a problem.
					-- HINT: there is also `S` from `flash` to directly select a
					-- (arbitrary) node region around the cursor
					init_selection = "<M-v>",
					node_incremental = "L",
					node_decremental = "H",
					scope_incremental = false, -- disabled, not needed
				},
			},

			-- See: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
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
						["]c"] = { query = "@class.outer", desc = "Next class start" },
					},
					goto_next_end = {
						["]M"] = { query = "@function.outer", desc = "Next function end" },
						["]C"] = { query = "@class.outer", desc = "Next class end" },
					},
					goto_previous_start = {
						["[m"] = { query = "@function.outer", desc = "Previous function start" },
						["[c"] = { query = "@class.outer", desc = "Previous class start" },
					},
					goto_previous_end = {
						["[M"] = { query = "@function.outer", desc = "Previous function end" },
						["[C"] = { query = "@class.outer", desc = "Previous class end" },
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
		},

		---@param opts TSConfig
		config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
	},

	-- AST based text objects
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			"folke/snacks.nvim",
			"folke/which-key.nvim",
			"lewis6991/gitsigns.nvim",
			"nvim-treesitter/nvim-treesitter",
		},

		config = function()
			local rep = require("nvim-treesitter.textobjects.repeatable_move")
			local gs = require("gitsigns")
			local sw = require("snacks.words")
			local wk = require("which-key")
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
			local next_hunk = function() gs.nav_hunk("next", { preview = false, target = "all" }) end
			local prev_hunk = function() gs.nav_hunk("prev", { preview = false, target = "all" }) end
			local next_hunk_preview = function() gs.nav_hunk("next", { preview = true, target = "all" }) end
			local prev_hunk_preview = function() gs.nav_hunk("prev", { preview = true, target = "all" }) end
			local next_hunk_rep, prev_hunk_rep = rep.make_repeatable_move_pair(next_hunk, prev_hunk)
			local next_hunk_preview_rep, prev_hunk_preview_rep =
				rep.make_repeatable_move_pair(next_hunk_preview, prev_hunk_preview)
			wk.add({
				{ mode = modes, "]h", next_hunk_rep, icon = "", desc = "Next Git change hunk" },
				{ mode = modes, "[h", prev_hunk_rep, icon = "", desc = "Previous Git change hunk" },
				{ mode = modes, "]H", next_hunk_preview_rep, icon = "", desc = "Next Git change hunk (preview)" },
				{
					mode = modes,
					"[H",
					prev_hunk_preview_rep,
					icon = "",
					desc = "Previous Git change hunk (preview)",
				},
			})

			-- Make diagnostics (mostly LSP) movements repeatable with ; and , keys
			local next_diag = function() vim.diagnostic.goto_next({ float = false }) end
			local prev_diag = function() vim.diagnostic.goto_prev({ float = false }) end
			local next_error = function()
				vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, float = false })
			end
			local prev_error = function()
				vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, float = false })
			end
			-- FIXME: next/prev diag are not repeatable for some reason
			local next_diag_rep, prev_diag_rep = rep.make_repeatable_move_pair(next_diag, prev_diag)
			local next_error_rep, prev_error_rep = rep.make_repeatable_move_pair(next_error, prev_error)
			wk.add({
				-- stylua: ignore start
				{ mode = modes, "]d", next_diag_rep, icon = { icon = "", color = "yellow" }, desc = "Next diagnostic" },
				{ mode = modes, "[d", prev_diag_rep, icon = { icon = "", color = "yellow" }, desc = "Previous diagnostic" },
				{ mode = modes, "]e", next_error_rep, icon = "", desc = "Next error" },
				{ mode = modes, "[e", prev_error_rep, icon = "", desc = "Previous error" },
				-- stylua: ignore end
			})

			-- Make Snacks word LSP reference movements repeatable with ; and , keys
			local function next_word() sw.jump(vim.v.count1, true) end
			local function prev_word() sw.jump(-vim.v.count1, true) end
			local next_word_rep, prev_word_rep = rep.make_repeatable_move_pair(next_word, prev_word)
			wk.add({
				{ mode = modes, "]w", next_word_rep, icon = "", desc = "Next word" },
				{ mode = modes, "[w", prev_word_rep, icon = "", desc = "Previous word" },
			})

			-- Next/previous spelling error (repeatable)
			local function next_spelling_error() vim.cmd("normal! ]s") end
			local function prev_spelling_error() vim.cmd("normal! [s") end
			local next_spelling_error_rep, prev_spelling_error_rep =
				rep.make_repeatable_move_pair(next_spelling_error, prev_spelling_error)
			wk.add({
				{ mode = modes, "]s", next_spelling_error_rep, icon = "󰓆", desc = "Next spelling error" },
				{ mode = modes, "[s", prev_spelling_error_rep, icon = "󰓆", desc = "Previous spelling error" },
			})
		end,
	},

	-- Keep context line at the top of the window
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = {
			"folke/which-key.nvim",
			"nvim-treesitter/nvim-treesitter",
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
