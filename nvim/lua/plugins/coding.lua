return {
	-- Automatically set indentation settings
	"nmac427/guess-indent.nvim",

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
	"stevearc/conform.nvim",

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

	-- GitHub Copilot
	"github/copilot.vim",
	"ofseed/copilot-status.nvim",

	-- Surround (there are alternatives and stuff, but this seems fine)
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = true,
	},

	-- Trouble: project wide diagnostics
	{
		"folke/trouble.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
	},
}
