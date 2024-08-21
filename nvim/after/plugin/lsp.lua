local lsp_zero = require("lsp-zero")
local lspconfig = require("lspconfig")

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"eslint",
		"lua_ls",
		"tsserver",
	},
})

require("neodev").setup()

-- NOTE: to see available LSP configs, see :help lspconfig-all

lspconfig.lua_ls.setup({
	-- Fix false positive undefined global '…'
	settings = { Lua = { diagnostics = { globals = { "vim", "P", "RELOAD", "R" } } } },
})

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

-- Julia (install julia-lsp with Mason)
-- Taken from https://www.juliabloggers.com/setting-up-julia-lsp-for-neovim
-- Make sure ~/.julia/environments/nvim-lspconfig is set up as described
-- Don't copy/paste makefile, instead download from here:
-- https://raw.githubusercontent.com/fredrikekre/.dotfiles/master/.julia/environments/nvim-lspconfig/Makefile
lspconfig.julials.setup({
	on_new_config = function(new_config, _)
		local julia = vim.fn.expand("~/.julia/environments/nvim-lspconfig/bin/julia")
		if require("lspconfig").util.path.is_file(julia) then
			new_config.cmd[1] = julia
		end
	end,
})

-- Go
-- NOTE: install gopls via apt, not Mason, at least when golang itself is
-- installed via apt, otherwise it complains about version stuff
lspconfig.gopls.setup({})

-- Shell scripts
lspconfig.bashls.setup({})

-- Python: Pyright (Mason)
lspconfig.pyright.setup({})

-- Zig
lspconfig.zls.setup({})

-- Nim: nimlangserver (Mason)
lspconfig.nim_langserver.setup({})

-- Completions
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

lsp_zero.on_attach(function(client, bufnr)
	-- for default key mappings, see:
	-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v2.x/doc/md/api-reference.md#lsp-actions
	lsp_zero.default_keymaps({
		buffer = bufnr,
		preserve_mappings = false,
	})

	local opts = { buffer = bufnr, remap = false, desc = "LSP: code action ([q]uickfix)" }
	vim.keymap.set("n", "<leader>q", vim.lsp.buf.code_action, opts)

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "tsserver" then
		vim.keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>")
		vim.keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>")
		vim.keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>")
	end

	-- highlight all references to symbol under cursor
	if client.server_capabilities.documentHighlightProvider then
		local LspDocumentHighlight = vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })

		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			callback = vim.lsp.buf.document_highlight,
			group = LspDocumentHighlight,
			buffer = bufnr,
			desc = "Highlight symbol under cursor",
		})

		vim.api.nvim_create_autocmd("CursorMoved", {
			callback = vim.lsp.buf.clear_references,
			group = LspDocumentHighlight,
			buffer = bufnr,
			desc = "Clear old highlights",
		})
	end
end)

lsp_zero.setup()

vim.diagnostic.config({
	virtual_text = true, -- show inline errors at the end of lines
})
