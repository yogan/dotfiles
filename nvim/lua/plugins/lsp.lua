local function configure_diagnostics()
	vim.diagnostic.config({
		-- NOTE: keep in sync with toggle in `snacks.lua`
		-- empty prefix (no block icon), and closer to the line of code
		virtual_text = { prefix = "", spacing = 2 },
		update_in_insert = false,
		float = {
			header = "",
			border = "rounded",
			focusable = true,
		},
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "󰅚",
				[vim.diagnostic.severity.WARN] = "󰀪",
				[vim.diagnostic.severity.HINT] = "󰌶",
				[vim.diagnostic.severity.INFO] = "",
			},
		},
	})
end

local function setup_lsp_keymaps()
	vim.keymap.set("n", "<leader>q", vim.lsp.buf.code_action, { remap = false, desc = "LSP: code action ([q]uickfix)" })
end

-- Deprecated, use setup_lspconfig() instead
local function setup_lspconfig()
	local lspconfig = require("lspconfig")

	-- Extended TypeScript LSP functionality from VS Code
	local vtsInlayHints = {
		parameterNames = { enabled = "literals" },
		parameterTypes = { enabled = true },
		variableTypes = { enabled = true },
		propertyDeclarationTypes = { enabled = true },
		functionLikeReturnTypes = { enabled = true },
		enumMemberValues = { enabled = true },
	}
	require("lspconfig.configs").vtsls = require("vtsls").lspconfig
	require("lspconfig").vtsls.setup({
		settings = {
			javascript = { inlayHints = vtsInlayHints },
			typescript = { inlayHints = vtsInlayHints },
		},
	})

	-- ESLint
	lspconfig.eslint.setup({})

	-- JSON with JSON Schema support, see:
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jsonls
	-- TL;DR: npm i -g vscode-langservers-extracted
	lspconfig.jsonls.setup({})

	-- YAML
	lspconfig.yamlls.setup({
		-- https://github.com/redhat-developer/yaml-language-server#language-server-settings
		settings = { yaml = { keyOrdering = false } },
	})

	-- Markdown (install marksman with Mason)
	lspconfig.marksman.setup({})

	-- No plugin needed, LSP is built-in, see:
	-- https://github.com/gleam-lang/gleam.vim?tab=readme-ov-file#neovim-users
	lspconfig.gleam.setup({})

	-- Crystal (install crystalline with Mason)
	lspconfig.crystalline.setup({})

	-- Clojure (install clojure-lsp with Mason)
	lspconfig.clojure_lsp.setup({})

	-- Haskell Language Server
	lspconfig.hls.setup({})

	-- C/C++ with Clang
	lspconfig.clangd.setup({
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			-- to fix this warning:
			-- multiple different client offset_encodings detected for buffer, this is not supported yet
			"--offset-encoding=utf-16",
		},
	})

	-- Rust
	lspconfig.rust_analyzer.setup({
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	})

	-- Perl Navigator
	lspconfig.perlnavigator.setup({
		-- The default is the Git root directory, but this breaks in my AoC
		-- solutions, where my Perl solutions are in a subdirectory.
		-- This might not be the right setting all the time, but there it works.
		root_dir = lspconfig.util.root_pattern("."),
	})

	-- Julia (install julia-lsp with Mason)
	-- Taken from https://www.juliabloggers.com/setting-up-julia-lsp-for-neovim
	-- Make sure ~/.julia/environments/nvim-lspconfig is set up as described
	-- Don't copy/paste makefile, instead download from here:
	-- https://raw.githubusercontent.com/fredrikekre/.dotfiles/master/.julia/environments/nvim-lspconfig/Makefile
	lspconfig.julials.setup({
		on_new_config = function(new_config, _)
			local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
			if (vim.uv.fs_stat(julia) or {}).type == "file" then
				new_config.cmd[1] = julia
			end
		end,
	})

	-- Go
	-- NOTE: install gopls via apt, not Mason, at least when golang itself is
	-- installed via apt, otherwise it complains about version stuff
	lspconfig.gopls.setup({})

	-- C# (install csharp-language-server via Mason)
	lspconfig.csharp_ls.setup({})

	-- Shell scripts
	lspconfig.bashls.setup({})

	-- fish LSP - needs to be build from source (easy), see:
	-- https://github.com/ndonfris/fish-lsp?tab=readme-ov-file#installation
	-- Copying fish-lsp to e.g. /usr/local/bin doesn't work, so:
	local fish_lsp_bin = os.getenv("HOME") .. "/src/fish-lsp/bin/fish-lsp"
	if vim.fn.filereadable(fish_lsp_bin) == 1 then
		lspconfig.fish_lsp.setup({ cmd = { fish_lsp_bin, "start" } })
	end

	-- Python: Pyright (Mason)
	lspconfig.pyright.setup({})

	-- Zig
	lspconfig.zls.setup({})

	-- Nim: nimlangserver (Mason)
	lspconfig.nim_langserver.setup({})

	-- Dart (works out of the box when dart is installed)
	lspconfig.dartls.setup({})

	-- OCaml (install ocaml-lsp via Mason)
	lspconfig.ocamllsp.setup({})
end

-- The new way.
local function enable_lsps() vim.lsp.enable("lua_ls") end

local function setup_cmp()
	local cmp = require("cmp")
	local lspkind = require("lspkind")

	cmp.setup({
		sources = {
			{ name = "nvim_lsp", keyword_length = 3 },
			{ name = "luasnip", keyword_length = 2, max_item_count = 10 },
			{ name = "buffer", keyword_length = 3, max_item_count = 15 },
			{ name = "path", keyword_length = 2 },
		},
		---@diagnostic disable-next-line: missing-fields
		formatting = {
			format = lspkind.cmp_format({
				mode = "symbol", -- only icons, not "method" etc. text
				ellipsis_char = "…",
			}),
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		mapping = {
			["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
			["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
			["<C-y>"] = cmp.mapping.confirm({ select = true }),
			["<C-Space>"] = cmp.mapping.complete(),
		},
	})
end

return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			setup_lspconfig() -- deprecated
			enable_lsps() -- the new way
			setup_lsp_keymaps()
			configure_diagnostics()
		end,
	},

	-- Mason to install and manage LSP servers
	-- FIXME: Mason is already at v2.x, which currently breaks with my config
	-- Pinning to v1.x for now, as recommended here: https://github.com/LazyVim/LazyVim/issues/6039
	{ "mason-org/mason.nvim", version = "^1.0.0", config = true },
	{ "mason-org/mason-lspconfig.nvim", version = "^1.0.0", opts = { ensure_installed = { "lua_ls" } } },

	-- Inline hints
	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		opts = { autoEnableHints = true },
		config = function(_, opts)
			require("lsp-endhints").setup(opts)

			-- start with a defined state (otherwise snacks toggles are wrong)
			vim.lsp.inlay_hint.enable(opts.autoEnableHints)
			vim.g.snacks_toggle_lsp_hints_end = opts.autoEnableHints
		end,
	},

	-- Completions
	{ "hrsh7th/nvim-cmp", config = setup_cmp },
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lua",
	"saadparwaiz1/cmp_luasnip",
	"onsails/lspkind-nvim", -- icons in completion menu

	-- Snippets
	{
		"L3MON4D3/LuaSnip",
		dependencies = "rafamadriz/friendly-snippets",
		config = function() require("luasnip.loaders.from_vscode").lazy_load() end,
	},

	-- LSP Fidget
	{ "j-hui/fidget.nvim", config = true },

	-- LSP-based renaming with live preview
	{
		"saecki/live-rename.nvim",
		config = function(_, opts)
			require("live-rename").setup(opts)
			local live_rename = require("live-rename")
			vim.keymap.set(
				"n",
				"<leader>r",
				live_rename.map({ text = "", insert = true }),
				{ desc = "LSP rename (clear)" }
			)
			vim.keymap.set( --
				"n", --
				"<leader>R",
				live_rename.map(),
				{ desc = "LSP rename (modify)" }
			)
		end,
	},

	-- Fancy diagnostic float windows for current line only
	-- Can be toggled via snacks (<leader>tv) to "regular" virtual text.
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		priority = 1000, -- needs to be loaded in first
		opts = { preset = "powerline" },
		config = function(_, opts)
			require("tiny-inline-diagnostic").setup(opts)
			vim.diagnostic.config({ virtual_text = false })
		end,
	},
}
