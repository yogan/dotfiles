local function session_name()
	local session_ok, session = pcall(require, "possession.session")
	if not session_ok or not session.session_name then
		return ""
	end
	return " " .. session.session_name
end

local function auto_format()
	-- see :FormatEnable and :FormatDisable in conform.lua
	---@diagnostic disable-next-line: undefined-field
	if vim.b.disable_autoformat or vim.g.disable_autoformat then
		return ""
	end
	return ""
end

local function indent_setting()
	if vim.opt.expandtab:get() then
		return "␣" .. vim.opt.shiftwidth:get()
	else
		return "↹"
	end
end

local noice = require("noice")

local function noice_message()
	local message = noice.api.status.message.get()

	local search_term = vim.fn.getreg("/")
	if search_term and message == "/" .. search_term then
		return "" -- don't show the search term as a message (redundant)
	end

	return message
end

local function noice_search()
	local search = noice.api.status.search.get()
	search = search:gsub("^/", "  "):gsub("^?", "  ")
	return search:gsub("%s+", " ")
end

require("lualine").setup({
	extensions = { "nvim-tree", "quickfix" },
	sections = {
		lualine_a = { session_name },
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
		},
		lualine_c = {
			{
				"filename",
				path = 1,
				symbols = {
					modified = "",
					readonly = "󰷤",
					unnamed = "",
					newfile = "",
				},
			},
		},
		lualine_x = {
			{
				noice_message,
				cond = function ()
					return noice.api.status.message.has() and vim.o.columns > 140
				end,
				color = { fg = "#868593" },
			},
			{
				noice_search,
				cond = noice.api.status.search.has,
				color = { fg = "#4f8ca6" },
			},
			indent_setting,
			"encoding",
			"fileformat",
			"filetype",
		},
	},
})
