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

local function lsp_clients()
	local buf = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients()
	local attached = {}
	local not_attached = {}

	for _, client in ipairs(clients) do
		if client.name ~= "GitHub Copilot" then
			if client.attached_buffers[buf] then
				table.insert(attached, client.name)
			else
				table.insert(not_attached, client.name)
			end
		end
	end

	return { attached, not_attached }
end

local function lsp_clients_number()
	local attached, not_attached = unpack(lsp_clients())

	if #attached == 0 and #not_attached == 0 then
		return ""
	end

	return "LSP " .. #attached .. "/" .. (#attached + #not_attached)
end

local function lsp_clients_notify()
	local attached, not_attached = unpack(lsp_clients())

	if #attached == 0 and #not_attached == 0 then
		return "No LSP clients attached"
	end

	local text = ""
	if #attached > 0 then
		text = text .. "󰖩 " .. table.concat(attached, ", ")
	end
	if text ~= "" and #not_attached > 0 then
		text = text .. "\n"
	end
	if #not_attached > 0 then
		text = text .. "󰖪 " .. table.concat(not_attached, ", ")
	end

	require("snacks.notify").info(text, {
		title = "LSP Clients",
		style = "fancy",
		id = "lsp_clients",
	})
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
					separator = "",
					padding = { left = 1, right = 0 },
				},
				{
					lsp_clients_number,
					padding = { left = 0, right = 1 },
					on_click = function(_, button, _)
						if button == "l" then
							lsp_clients_notify()
						elseif button == "r" then
							require("snacks.picker").lsp_config({ attached = true })
						end
					end,
				},
				{
					"copilot",
					show_running = true,
					symbols = {
						spinners = require("copilot-status.spinners").arc,
						status = { enabled = "", disabled = "" },
					},
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
