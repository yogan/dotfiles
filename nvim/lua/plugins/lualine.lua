local function trunc(hide_width, trunc_width, trunc_len, max_len)
	return function(str)
		local win_width = vim.fn.winwidth(0)
		if hide_width and win_width < hide_width then
			return ""
		elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
			return str:sub(1, trunc_len) .. "…"
		elseif max_len and #str > max_len then
			return str:sub(1, max_len) .. "…"
		end
		return str
	end
end

local function macro()
	local reg = vim.fn.reg_recording()
	if reg == "" then
		return ""
	end
	return " REC " .. reg
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
			lualine_b = {
				{
					"branch",
					fmt = trunc(90, 124, 16, 40),
					on_click = function() require("snacks.picker").git_branches() end,
				},
			},
			lualine_c = {
				{
					"filename",
					path = 1,
					symbols = file_symbols,
					on_click = function() require("snacks.picker").files() end,
				},
			},
			lualine_x = { "location", "selectioncount" },
			lualine_y = {
				{
					"filetype",
					colored = false,
					icon_only = true,
					padding = { left = 1, right = 0 },
				},
				{
					"copilot",
					show_running = true,
					symbols = {
						spinners = require("copilot-status.spinners").arc,
						status = { enabled = "", disabled = "" },
					},
				},
				{
					"lsp_status",
					padding = { left = 0, right = 1 },
					icon = "",
					ignore_lsp = { "GitHub Copilot" },
					on_click = function() require("snacks.picker").lsp_config({ attached = true }) end,
				},
			},
			lualine_z = {},
		},
		winbar = {
			lualine_b = {
				{
					"filetype",
					colored = true,
					icon_only = true,
					separator = "",
					padding = { left = 1, right = 0 },
					on_click = function() require("snacks.picker").buffers() end,
				},
				{
					"filename",
					path = 0,
					symbols = file_symbols,
					padding = { left = 0, right = 1 },
					on_click = function() require("snacks.picker").buffers() end,
				},
			},
			lualine_x = {
				{
					"diagnostics",
					on_click = function() require("snacks.picker").diagnostics_buffer() end,
				},
			},
			lualine_y = {
				{
					"diff",
					on_click = function() require("gitsigns.actions").diffthis() end,
				},
			},
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
