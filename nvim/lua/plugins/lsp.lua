-- NOTE: to see available LSP configs, see :help lspconfig-all
local function setup_lspconfig()
	local lspconfig = require("lspconfig")

	lspconfig.lua_ls.setup({})

	-- Extended TypeScript LSP functionality from VS Code
	require("lspconfig.configs").vtsls = require("vtsls").lspconfig
	require("lspconfig").vtsls.setup({})

	-- JSON with JSON Schema support, see:
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jsonls
	-- TL;DR: npm i -g vscode-langservers-extracted
	lspconfig.jsonls.setup({})

	lspconfig.eslint.setup({})

	lspconfig.yamlls.setup({
		-- https://github.com/redhat-developer/yaml-language-server#language-server-settings
		settings = { yaml = { keyOrdering = false } },
	})

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
	lspconfig.fish_lsp.setup({
		-- copying just fish-lsp to e.g. /usr/local/bin doesn't work, so:
		cmd = { os.getenv("HOME") .. "/src/fish-lsp/bin/fish-lsp", "start" },
	})

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

local function setup_lsp_zero()
	local lsp_zero = require("lsp-zero")

	---@diagnostic disable-next-line: unused-local
	lsp_zero.on_attach(function(client, bufnr)
		-- for default key mappings, see:
		-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#lsp-actions
		lsp_zero.default_keymaps({
			buffer = bufnr,
			preserve_mappings = false,
			-- Skipping some default mappings, using Snacks instead (see snacks.lua)
			omit = { "gd", "gD", "gr", "gi", "gy", "<F2>" },
		})

		vim.keymap.set("n", "<F2>", ":IncRename ", { buffer = bufnr })

		local opts = { buffer = bufnr, remap = false, desc = "LSP: code action ([q]uickfix)" }
		vim.keymap.set("n", "<leader>q", vim.lsp.buf.code_action, opts)
	end)

	lsp_zero.setup()
end

local function setup_diagnostics()
	vim.diagnostic.config({
		virtual_text = true, -- show inline errors at the end of lines
		update_in_insert = false,
		float = {
			header = "",
			border = "rounded",
			focusable = true,
		},
	})

	-- Diagnostic icons in gutter, see:
	-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#change-diagnostic-symbols-in-the-sign-column-gutter
	local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
	end
end

return {
	{
		"VonHeikemen/lsp-zero.nvim",
		branch = "v2.x",
		config = function()
			setup_lsp_zero()
			setup_diagnostics()
		end,
	},

	{ "neovim/nvim-lspconfig", config = setup_lspconfig },

	-- Mason to install and manage LSP servers
	{ "williamboman/mason.nvim", config = true },
	{ "williamboman/mason-lspconfig.nvim", opts = { ensure_installed = { "lua_ls" } } },

	-- Completions
	{ "hrsh7th/nvim-cmp", config = setup_cmp },
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lua",
	"saadparwaiz1/cmp_luasnip",
	"onsails/lspkind-nvim", -- icons in completion menu

	-- Snippets
	"L3MON4D3/LuaSnip",
	"rafamadriz/friendly-snippets",

	-- LSP Fidget
	{ "j-hui/fidget.nvim", config = true },

	-- Improved LSP renaming (live preview)
	{ "smjonas/inc-rename.nvim", config = true },
}
