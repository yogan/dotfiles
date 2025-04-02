return {
	-- Automatically set indentation settings
	{
		"nmac427/guess-indent.nvim",
		opts = { filetype_exclude = { "gitcommit", "markdown", "text" } },
	},

	-- Better folding
	{
		"kevinhwang91/nvim-ufo",
		dependencies = {
			"folke/which-key.nvim",
			"kevinhwang91/promise-async",
		},
		config = function()
			local ufo = require("ufo")
			local wk = require("which-key")

			local ftMap = {
				markdown = "treesitter",
				yaml = "indent",
				-- add empty entry when a ft shall have no folding
			}

			---@diagnostic disable-next-line: missing-fields
			ufo.setup({
				provider_selector = function(_, filetype)
					return ftMap[filetype] -- default fallback is { "lsp", "indent" }
				end,
			})

			local function map(l, r, desc) wk.add({ { mode = "n", l, r, desc = desc, icon = "󱃅" } }) end

			local function peek()
				local winid = ufo.peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end

			map("zR", ufo.openAllFolds, "Open all folds")
			map("zM", ufo.closeAllFolds, "Close all folds")
			map("zK", peek, "Peek Fold")
		end,
	},

	-- Commenting stuff
	{
		"numToStr/Comment.nvim",
		dependencies = {
			{
				"JoosepAlviste/nvim-ts-context-commentstring",
				opts = { enable_autocmd = false },
			},
		},
		opts = {
			-- Changed default gb/gbc prefix to gC/gCC for blockwise comments,
			-- so that <leader>gb can be mapped to git blame.
			toggler = { line = "gcc", block = "gCC" },
			opleader = { line = "gc", block = "gC" },
		},
		config = function(_, opts)
			opts.pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()

			require("Comment").setup(opts)

			local ft = require("Comment.ft")
			ft.set("gitconfig", "# %s") -- default is ; but all my stuff uses # (both work)

			if vim.g.neovide then
				vim.keymap.set("n", "<C-/>", "<Plug>(comment_toggle_linewise_current)", { desc = "Toggle comment" })
				vim.keymap.set("v", "<C-/>", "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle comment" })
			else
				-- Ctrl+/ is <C-_>, see https://vi.stackexchange.com/a/26617
				vim.keymap.set("n", "<C-_>", "<Plug>(comment_toggle_linewise_current)", { desc = "Toggle comment" })
				vim.keymap.set("v", "<C-_>", "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle comment" })
			end
		end,
	},

	-- Todo comments
	{
		"folke/todo-comments.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		opts = {
			keywords = {
				-- concatenation hacks to avoid being detected here
				FIX = {
					icon = " ",
					color = "error",
					alt = { "F" .. "IXME", "F" .. "IXIT", "B" .. "UG", "B" .. "UGS" },
				},
				WARN = {
					icon = " ",
					color = "warning",
					alt = { "W" .. "ARNING", "W" .. "ARNINGS", "A" .. "TTENTION" },
				},
				["T" .. "ODO"] = {
					icon = " ",
					color = "info",
					alt = { "T" .. "ODOS", "I" .. "SSUE", "I" .. "SSUES" },
				},
				["N" .. "OTE"] = {
					icon = "󰎞 ",
					color = "hint",
					alt = { "N" .. "OTES", "I" .. "NFO", "I" .. "NFOS", "H" .. "INT", "H" .. "INTS" },
				},
			},
			merge_keywords = false, -- use only keywords listed above, don't include defaults
			highlight = {
				before = "",
				keyword = "wide_bg",
				after = "fg",
				-- Listing the pattern twice is a workaround. The trailing : shall be optional,
				-- which should work with e.g. :\? or :\= or :\{,1} or some other vim regex magic,
				-- but of course it does not. So let's just pass a table with both
				-- variants and move on with our live.
				pattern = { [[<(KEYWORDS)>:]], [[<(KEYWORDS)>]] }, -- vim syntax
				comments_only = true, -- uses treesitter to match keywords in comments only
			},
			search = {
				pattern = [[\b(KEYWORDS):?\b]], -- ripgrep regex
			},
		},
	},

	-- (Auto) Formatting
	{
		"stevearc/conform.nvim",
		dependencies = "folke/which-key.nvim",
		opts = {
			formatters = {
				gleam = {
					command = "gleam",
					args = { "format", "--stdin" },
					stdin = true,
				},
				fprettify = {
					command = "fprettify", -- can be installed with Mason
					stdin = true,
				},
			},

			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" }, -- run all in given order
				sh = { "shfmt" },
				-- use prettierd if available, otherwise fallback to prettier
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				gleam = { "gleam" },
				nim = { "nimpretty" },
				elm = { "elm_format" },
				fortran = { "fprettify" },
				swift = { "swiftformat" }, -- install: clone and build: https://github.com/nicklockwood/SwiftFormat
				perl = { "perltidy" }, -- install with cpan Perl::Tidy
				crystal = { "crystal" },
				-- TODO: csharpier does a pretty bad job, and dotnet format is slow as
				-- fuck; find something else
				-- csharp = { "csharpier" }, -- install with Mason
				ocaml = { "ocamlformat" }, -- install ocamlformat with Mason
			},

			format_on_save = function(bufnr)
				-- Disable autoformat on certain filetypes
				local ignore_filetypes = { "sh", "bash" }
				if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
					return
				end

				-- Disable with a global or buffer-local variable
				-- Toggles for those are in snacks.lua
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end

				return { timeout_ms = 500, lsp_fallback = true }
			end,
		},
		config = function(_, opts)
			local conform = require("conform")
			conform.setup(opts)

			require("which-key").add({
				{
					mode = { "n", "v" },
					"<leader>f",
					function() conform.format({ timeout_ms = 500, lsp_fallback = true }) end,
					desc = "Format file or range (in visual mode)",
					icon = "󰊄",
				},
			})
		end,
	},

	-- Highlighting and trimming of trailing whitespace
	{
		"ntpeters/vim-better-whitespace",
		-- Loading the plugin on this event helps that the initial Snacks dashboard
		-- has its filetype set to 'snacks_dashboard', see:
		-- https://github.com/folke/snacks.nvim/issues/1220#issuecomment-2661542968
		event = "BufReadPost",
		init = function()
			-- Strip whitespace operator, also works on visual selection
			-- Operator mode examples:
			--    <leader>Wj  - current line
			--    <leader>Wap - current paragraph
			--    <leader>Wib - current block (e.g. {…})
			--    <leader>Wig - current git change hunk
			vim.g.better_whitespace_operator = "<leader>W"

			vim.g.better_whitespace_filetypes_blacklist = {
				"diff",
				"git",
				"gitcommit",
				"unite",
				"qf",
				"help",
				"markdown",
				"fugitive",
				"snacks_dashboard",
				"",
			}
		end,
	},

	-- Git column, inline diffs, blaming, etc.
	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			"folke/snacks.nvim",
			"folke/which-key.nvim",
		},
		event = "BufRead",
		config = function()
			local sp = require("snacks.picker")
			local wk = require("which-key")

			require("gitsigns").setup({
				on_attach = function(bufnr)
					local function map(mode, l, r, desc)
						wk.add({
							{ mode = mode, l, r, buffer = bufnr, desc = desc, icon = "" },
							group = "Git Signs",
						})
					end

					local gs = package.loaded.gitsigns

					-- Actions
					map({ "n", "v" }, "<leader>ga", gs.stage_hunk, "Stage hunk")
					map({ "n", "v" }, "<leader>gr", gs.reset_hunk, "Reset hunk")
					map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
					map("n", "<leader>gA", gs.stage_buffer, "Stage file")
					map("n", "<leader>gR", gs.reset_buffer, "Reset file")
					map("n", "<leader>gg", gs.preview_hunk, "Diff hunk")
					map("n", "<leader>gd", gs.diffthis, "Diff file")
					map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff file (staged)")
					map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame popup")

					-- Text object (e.g. vig -> select current hunk)
					map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")

					-- NOTE:
					-- * Repeatable git hunk movements are in `treesitter.lua`
					-- * Gitsigns toggle mappings are in `snacks.lua`
				end,
			})

			-- Snack's Git key mappings (to have them all in one place)
			local function map(l, r, desc)
				wk.add({
					{ mode = "n", l, r, desc = desc, icon = "" },
					group = "Snacks Git",
				})
			end

			map("<leader>gB", sp.git_branches, "Branches")
			map("<leader>gl", sp.git_log, "Log")
			map("<leader>gL", sp.git_log_line, "Log Line")
			map("<leader>gk", sp.git_log_file, "Log File")
			map("<leader>gs", sp.git_status, "Status")
			map("<leader>gh", sp.git_stash, "Stash")
			map("<leader>gz", function() Snacks.lazygit.open() end, "LazyGit")
			map("<leader>gZ", function() Snacks.lazygit.log() end, "LazyGit Log")
			map("<leader>gK", function() Snacks.lazygit.log_file() end, "LazyGit Log File")
		end,
	},

	-- Surround
	{
		"kylechui/nvim-surround",
		version = "^3.0.0*",
		event = "VeryLazy",
		opts = {
			keymaps = {
				visual = "gs", -- default is S, but this clashes with leap
				visual_line = false, -- I don't see the point to surround full lines
			},
		},
	},

	-- Trouble: project wide diagnostics
	{
		"folke/trouble.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		cmd = "Trouble",
		opts = {},
		keys = {
			{
				"<leader>xx",
				"<Cmd>Trouble diagnostics toggle<CR>",
				desc = "Diagnostics",
			},
			{
				"<leader>xb",
				"<Cmd>Trouble diagnostics toggle filter.buf=0<CR>",
				desc = "Buffer Diagnostics",
			},
			{
				"<leader>xs",
				"<Cmd>Trouble symbols toggle focus=false<CR>",
				desc = "Symbols",
			},
			{
				"<leader>xr",
				"<Cmd>Trouble lsp toggle focus=false win.position=right<CR>",
				desc = "LSP References/Definitions/…",
			},
			{
				"<leader>xl",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xq",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},

	-- GitHub Copilot
	{
		"github/copilot.vim",
		dependencies = "ofseed/copilot-status.nvim",
		init = function()
			vim.g.copilot_filetypes = {
				["*"] = false,
				["autohotkey"] = true,
				["awk"] = true,
				["bash"] = true,
				["c"] = true,
				["clojure"] = true,
				["cpp"] = true,
				["crystal"] = true,
				["cs"] = true,
				["css"] = true,
				["dart"] = true,
				["dockerfile"] = true,
				["elixir"] = true,
				["elm"] = true,
				["erlang"] = true,
				["fish"] = true,
				["fortran"] = true,
				["gitcommit"] = true,
				["gleam"] = true,
				["go"] = true,
				["groovy"] = true,
				["haskell"] = true,
				["html"] = true,
				["idris2"] = true,
				["java"] = true,
				["javascript"] = true,
				["javascriptreact"] = true,
				["json"] = true,
				["jsx"] = true,
				["julia"] = true,
				["kotlin"] = true,
				["lua"] = true,
				["markdown"] = true,
				["matlab"] = true,
				["mdx"] = true,
				["mips"] = true,
				["nim"] = true,
				["ocaml"] = true,
				["octave"] = true,
				["perl"] = true,
				["php"] = true,
				["prolog"] = true,
				["ps1"] = true,
				["python"] = true,
				["r"] = true,
				["ruby"] = true,
				["rust"] = true,
				["scala"] = true,
				["scheme"] = true,
				["scss"] = true,
				["sh"] = true,
				["sml"] = true,
				["sql"] = true,
				["swift"] = true,
				["tcl"] = true,
				["text"] = true,
				["toml"] = true,
				["typescript"] = true,
				["typescriptreact"] = true,
				["vim"] = true,
				["yaml"] = true,
				["zig"] = true,
			}
		end,
	},
}
