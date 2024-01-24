local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" }, -- run all in given order
		sh = { "shfmt" },
		-- sub list uses only first available (here: prettierd before prettier)
		javascript = { { "prettierd", "prettier" } },
		typescript = { { "prettierd", "prettier" } },
		javascriptreact = { { "prettierd", "prettier" } },
		typescriptreact = { { "prettierd", "prettier" } },
	},

	format_on_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 500, lsp_fallback = true }
	end,
})

require("conform").formatters.shfmt = {
	prepend_args = { "-i", "4" },
}

-- Source: https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#command-to-toggle-format-on-save
vim.api.nvim_create_user_command("FormatDisable", function(args)
	---@type table<any, any>
	vim.b = vim.b -- to make luals happy
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

vim.g.disable_autoformat = true -- start without auto format on save by default

vim.keymap.set("n", "<leader>tfe", ":FormatEnable<CR>", { desc = "Enable auto format on save" })
vim.keymap.set("n", "<leader>tfd", ":FormatDisable<CR>", { desc = "Disable auto format on save" })
vim.keymap.set("n", "<leader>tfb", ":FormatDisable!<CR>", { desc = "Disable auto format on save (buffer)" })

vim.keymap.set({ "n", "v" }, "<leader>f", function()
	conform.format({ timeout_ms = 500, lsp_fallback = true })
end, { desc = "Format file or range (in visual mode)" })
