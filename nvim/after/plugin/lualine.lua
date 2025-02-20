local function session_name()
	local session_ok, session = pcall(require, "possession.session")
	if not session_ok or not session.get_session_name() then
		return ""
	end
	return " " .. session.get_session_name()
end

local function auto_format()
	-- see usage in conform.lua and toggle in snacks.lua
	---@diagnostic disable-next-line: undefined-field
	if vim.b.disable_autoformat or vim.g.disable_autoformat then
		return "󰉥"
	end
	return "󰊄"
end

local function indent_setting()
	---@diagnostic disable-next-line: undefined-field
	if vim.opt.expandtab:get() then
		---@diagnostic disable-next-line: undefined-field
		return vim.opt.shiftwidth:get() .. "␣"
	else
		return "↹"
	end
end

local file_symbols = {
	modified = "",
	readonly = "󰷤",
	unnamed = "",
	newfile = "",
}

require("lualine").setup({
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
			},
		},
	},
	sections = {
		lualine_a = { session_name },
		lualine_b = { "branch" },
		lualine_c = {
			{
				"filename",
				path = 1,
				symbols = file_symbols,
			},
		},
		lualine_x = { "location", "selectioncount" },
		lualine_y = {
			indent_setting,
			auto_format,
			{
				"copilot",
				show_running = true,
				symbols = {
					spinners = require("copilot-status.spinners").dots,
				},
				padding = { left = 1, right = 0 },
			},
		},
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
})
