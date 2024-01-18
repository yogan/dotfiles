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
		lualine_x = { indent_setting, "encoding", "fileformat", "filetype" },
	},
})
