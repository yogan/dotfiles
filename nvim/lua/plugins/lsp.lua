local function enable_lsps()
	vim.lsp.enable("bashls") -- Bash (install bash-language-server with Mason)
	vim.lsp.enable("biome") -- Biome (usually installed project-locally via npm)
	vim.lsp.enable("cssls") -- CSS (install css-lsp with Mason)
	vim.lsp.enable("clangd") -- C/C++ with Clang (install clangd with Mason)
	vim.lsp.enable("clojure_lsp") -- Clojure (install clojure-lsp with Mason)
	vim.lsp.enable("crystalline") -- Crystal (install crystalline with Mason)
	vim.lsp.enable("csharp_ls") -- C# (install csharp-language-server via Mason)
	vim.lsp.enable("dartls") -- Dart (works out of the box when dart is installed)
	vim.lsp.enable("eslint") -- ESLint (package-local npm version will be used)
	vim.lsp.enable("fish_lsp") -- fish (download bin to ~/.local/bin, see https://github.com/ndonfris/fish-lsp?tab=readme-ov-file#download-standalone-binary)
	vim.lsp.enable("gleam") -- Gleam (no plugin needed, LSP is built-in)
	vim.lsp.enable("gopls") -- Go (install gopls via apt, not Mason, at least when golang itself is installed via apt, otherwise it complains about version stuff)
	vim.lsp.enable("hls") -- Haskell (stack install haskell-language-server and never touch it again when it works, Haskell toolchain is a bitch)
	vim.lsp.enable("jsonls") -- JSON with JSON Schema support, npm i -g vscode-langservers-extracted
	vim.lsp.enable("julials") -- Julia (install julia-lsp with Mason)
	vim.lsp.enable("lua_ls") -- Lua (install lua-language-server with Mason)
	vim.lsp.enable("marksman") -- Markdown (install marksman with Mason)
	vim.lsp.enable("nim_langserver") -- Nim (install nimlangserver with Mason)
	vim.lsp.enable("ocamllsp") -- OCaml (install ocaml-lsp with Mason)
	vim.lsp.enable("perlnavigator") -- Perl (install perlnavigator with Mason)
	vim.lsp.enable("pyright") -- Python (install pyright with Mason)
	vim.lsp.enable("rust_analyzer") -- Rust (install rust-analyzer with Mason)
	vim.lsp.enable("vtsls") -- TypeScript (install vtsls with Mason)
	vim.lsp.enable("yamlls") -- YAML (install yaml-language-server with Mason)
	vim.lsp.enable("zls") -- Zig (install zls with Mason)
end

local function setup_lsp_keymaps()
	vim.keymap.set("n", "<leader>q", vim.lsp.buf.code_action, { remap = false, desc = "LSP: code action ([q]uickfix)" })
end

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
			enable_lsps()
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
