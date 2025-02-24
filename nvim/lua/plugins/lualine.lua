local function macro()
	local reg = vim.fn.reg_recording()
	if reg == "" then
		return ""
	end
	return " REC " .. reg
end

-- TODO a click handler that shows the names of the LSP clients in a floating
-- popup would be nice
local function lsp_clients()
	local current_buffer = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = current_buffer })
	if not clients then
		return ""
	end
	return " LSP " .. #clients
end

local file_symbols = {
	modified = "",
	readonly = "󰷤",
	unnamed = "",
	newfile = "",
}

return {
	"nvim-lualine/lualine.nvim",
	opts = {
		extensions = { "trouble" },
		options = {
			disabled_filetypes = {
				statusline = {
					"snacks_dashboard",
				},
				winbar = {
					"NvimTree",
					"TelescopePrompt",
					"TelescopeResults",
					"Trouble",
					"WhichKey",
					"packer",
					"qf",
					"snacks_dashboard",
					"oil",
				},
			},
		},
		sections = {
			lualine_a = { macro },
			lualine_b = { "branch" },
			lualine_c = {
				{
					"filename",
					path = 1,
					symbols = file_symbols,
				},
			},
			lualine_x = { "location", "selectioncount" },
			lualine_y = { "filetype", lsp_clients },
			lualine_z = {},
		},
		winbar = {
			lualine_b = {
				{
					"filetype",
					colored = false,
					icon_only = true,
					separator = "",
					padding = { left = 1, right = 0 },
				},
				{
					"filename",
					path = 0,
					symbols = file_symbols,
					padding = { left = 0, right = 1 },
				},
			},
			lualine_x = { "diagnostics" },
			lualine_y = { "diff" },
		},
		inactive_winbar = {
			lualine_c = {
				{
					"filetype",
					colored = false,
					icon_only = true,
					separator = "",
					padding = { left = 1, right = 0 },
				},
				{
					"filename",
					path = 0,
					symbols = file_symbols,
					padding = { left = 0, right = 1 },
				},
			},
		},
	},
}
