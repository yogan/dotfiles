local function session_name()
	local session_ok, session = pcall(require, "possession.session")
	if not session_ok or not session.get_session_name() then
		return ""
	end
	return " " .. session.get_session_name()
end

local function auto_format()
	-- see :FormatEnable and :FormatDisable in conform.lua
	---@diagnostic disable-next-line: undefined-field
	if vim.b.disable_autoformat or vim.g.disable_autoformat then
		return ""
	end
	return ""
end

local function indent_setting()
	if vim.opt.expandtab:get() then
		return vim.opt.shiftwidth:get() .. " ␣"
	else
		return "↹"
	end
end

local noice = require("noice")

local function noice_search()
	---@diagnostic disable-next-line: undefined-field
	local search = noice.api.status.search.get()
	search = search:gsub("^/", "  "):gsub("^?", "  ")
	return search:gsub("%s+", " ")
end

local file_symbols = {
	modified = "●",
	readonly = "󰷤",
	unnamed = "",
	newfile = "",
}

require("lualine").setup({
	extensions = { "neo-tree", "trouble" },
	options = {
		disabled_filetypes = {
			winbar = {
				"NvimTree",
				"TelescopePrompt",
				"TelescopeResults",
				"Trouble",
				"WhichKey",
				"alpha",
				"help",
				"neo-tree",
				"packer",
				"qf",
			},
		},
	},
	sections = {
		lualine_a = {
			session_name,
		},
		lualine_b = {
			{
				"copilot",
				show_running = true,
				symbols = {
					status = {
						enabled = " ",
						disabled = "",
					},
					spinners = require("copilot-status.spinners").dots,
				},
			},
			auto_format,
			{
				---@diagnostic disable-next-line: undefined-field
				noice.api.status.mode.get,
				---@diagnostic disable-next-line: undefined-field
				cond = noice.api.status.mode.has,
			},
		},
		lualine_c = {
			{
				"filename",
				path = 1,
				symbols = file_symbols,
			},
		},
		lualine_x = {
			{
				---@diagnostic disable-next-line: undefined-field
				noice.api.status.message.get,
				cond = function()
					---@diagnostic disable-next-line: undefined-field
					return noice.api.status.message.has() --
						---@diagnostic disable-next-line: undefined-field
						and not noice.api.status.search.has()
						and vim.o.columns > 140
				end,
				color = { fg = "#7b7a89" },
			},
			{
				noice_search,
				---@diagnostic disable-next-line: undefined-field
				cond = noice.api.status.search.has,
				color = { fg = "#4f8ca6" },
			},
			indent_setting,
			"encoding",
			"fileformat",
			"filetype",
		},
	},
	winbar = {
		lualine_a = {
			{
				"buffers",
				use_mode_colors = true,
			},
		},
	},
	inactive_winbar = {
		lualine_a = {
			{
				"filetype",
				colored = false,
				icon_only = true,
				separator = "",
				padding = 0,
			},
			{
				"filename",
				path = 0,
				symbols = file_symbols,
			},
		},
	},
})
