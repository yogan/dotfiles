local conform = require("conform")

conform.setup({
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
})

require("conform").formatters.shfmt = {
	prepend_args = { "-i", "4" },
}

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	conform.format({ timeout_ms = 500, lsp_fallback = true })
end, { desc = "Format file or range (in visual mode)" })
