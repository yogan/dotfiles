---@diagnostic disable-next-line: missing-fields
require("nvim-treesitter.configs").setup({
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
		-- `false` will disable the whole extension
		enable = true,

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
})
