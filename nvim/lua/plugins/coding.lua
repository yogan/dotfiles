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
			"kevinhwang91/promise-async",
			"luukvbaal/statuscol.nvim",
		},
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
	{ "folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim" },

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
					function()
						conform.format({ timeout_ms = 500, lsp_fallback = true })
					end,
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
	"lewis6991/gitsigns.nvim",

	-- Surround (there are alternatives and stuff, but this seems fine)
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = true,
	},

	-- Trouble: project wide diagnostics
	{ "folke/trouble.nvim", dependencies = "nvim-tree/nvim-web-devicons" },

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
