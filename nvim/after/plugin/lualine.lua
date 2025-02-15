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

-- local function indent_setting()
-- 	---@diagnostic disable-next-line: undefined-field
-- 	if vim.opt.expandtab:get() then
-- 		---@diagnostic disable-next-line: undefined-field
-- 		return vim.opt.shiftwidth:get() .. " ␣"
-- 	else
-- 		return "↹"
-- 	end
-- end

local noice = require("noice")

local function noice_search()
	---@diagnostic disable-next-line: undefined-field
	local search = noice.api.status.search.get()
	search = search:gsub("^/", "  "):gsub("^?", "  ")
	return search:gsub("%s+", " ")
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
			winbar = {
				"NvimTree",
				"TelescopePrompt",
				"TelescopeResults",
				"Trouble",
				"WhichKey",
				"alpha",
				"packer",
				"qf",
			},
		},
	},
	sections = {
		lualine_a = {},
		lualine_b = { session_name },
		lualine_c = {
			{
				"filename",
				path = 1,
				symbols = file_symbols,
			},
		},
		lualine_x = { "location" },
		lualine_y = {
			{ auto_format },
			{
				"copilot",
				show_running = true,
				symbols = {
					spinners = require("copilot-status.spinners").dots,
				},
			},
		},
		lualine_z = { noice_search },
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
		lualine_y = { "branch", "diff" },
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
