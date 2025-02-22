local function has_session()
	local p = require("persistence")
	local cur = p.current()
	for _, session in ipairs(p.list()) do
		if session == cur then
			return true
		end
	end
	return false
end

local function hide_cursor_in_dashboard()
	vim.api.nvim_create_autocmd("User", {
		pattern = "SnacksDashboardOpened",
		callback = function()
			local hl = vim.api.nvim_get_hl(0, { name = "Cursor", create = true })
			hl.blend = 100
			---@diagnostic disable-next-line: param-type-mismatch
			vim.api.nvim_set_hl(0, "Cursor", hl)
			vim.cmd("set guicursor+=a:Cursor/lCursor")
		end,
	})

	vim.api.nvim_create_autocmd("User", {
		pattern = "SnacksDashboardClosed",
		callback = function()
			local hl = vim.api.nvim_get_hl(0, { name = "Cursor", create = true })
			hl.blend = 0
			---@diagnostic disable-next-line: param-type-mismatch
			vim.api.nvim_set_hl(0, "Cursor", hl)
			vim.cmd("set guicursor+=a:Cursor/lCursor")
		end,
	})
end

return {
	"folke/snacks.nvim",
	dependencies = {
		"folke/persistence.nvim",
		"folke/which-key.nvim",
		"lewis6991/gitsigns.nvim",
		"github/copilot.vim",
		"ofseed/copilot-status.nvim",
	},
	---@type snacks.plugins.Config
	opts = {
		picker = {
			enabled = true,
			win = {
				input = {
					bo = {
						textwidth = 0,
					},
				},
				preview = {
					wo = {
						number = false,
						spell = false,
						wrap = false,
						statuscolumn = "",
						foldcolumn = "0",
					},
				},
			},
		},
		toggle = {
			which_key = true,
			notify = true,
			icon = {
				enabled = " ",
				disabled = " ",
			},
			color = {
				enabled = "yellow",
				disabled = "red",
			},
			wk_desc = {
				enabled = "",
				disabled = "",
			},
		},
		bigfile = { enabled = true },
		dashboard = {
			enabled = true,
			preset = {
				-- stylua: ignore start
				keys = {
					{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
					{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "g", desc = "Grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
					{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
					{ icon = " ", key = "c", desc = "Configure NeoVim", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
					{ icon = " ", key = "s", desc = "Session Restore", enabled = has_session, section = "session" },
					{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
				-- stylua: ignore end
			},
			sections = {
				{
					section = "terminal",
					cmd = "nvim-logo.sh",
					ttl = 5, -- sec.; so that cached output (~/.cache/nvim/snacks)
					--	              won't break animation
					random = 420, -- for some reason this helps to avoid showing an
					--               old logo for a short time before the new one
					height = 12,
					width = 69,
					indent = -5,
				},
				{ section = "keys", indent = 2, padding = 2, gap = 1 },
				{ section = "startup", padding = 2 },
			},
		},
		words = { enabled = true },
		zen = {
			-- You can add any `Snacks.toggle` id here.
			-- Toggle state is restored when the window is closed.
			-- Toggle config options are NOT merged.
			toggles = {
				dim = true,
				mini_diff_signs = false,
				inlay_hints = false,
				spell = false,
				number = false,
				relativenumber = false,
				foldcolumn = false,
				git_blame = false,
				git_signs = false,
				git_sign_column = false,
				diag_virtual_text = false,
			},
			win = {
				-- Based on the default from:
				-- https://github.com/folke/snacks.nvim/blob/main/docs/zen.md#zen
				style = {
					enter = true,
					fixbuf = false,
					minimal = false,
					width = 120,
					height = 0,
					backdrop = { transparent = true, blend = 15 },
					keys = { q = false },
					zindex = 40,
					wo = {
						winhighlight = "NormalFloat:Normal",
					},
					w = {
						snacks_main = true,
					},
				},
			},
		},
	},
	config = function(_, opts)
		require("snacks").setup(opts)

		hide_cursor_in_dashboard()

		local sp = require("snacks.picker")
		local wk = require("which-key")

		local function map(l, r, desc, mode)
			wk.add({
				{ mode = mode or "n", l, r, desc = desc },
				group = "Snacks",
			})
		end

		local function map_with_icon(l, r, desc, icon, mode)
			wk.add({
				{ mode = mode or "n", l, r, desc = desc, icon = icon },
				group = "Snacks",
			})
		end

		local function smart_picker()
			sp.smart({ hidden = true })
		end

		-- NOTE: keep in sync with definitions in todo-comments.lua
		local function comments_todo()
			---@diagnostic disable-next-line: undefined-field
			sp.todo_comments({
				keywords = {
					"FIXME",
					"FIXIT",
					"BUG",
					"BUGS",
					"WARNING",
					"WARNINGS",
					"ATTENTION",
					"TODO",
					"TODOS",
					"ISSUE",
					"ISSUES",
					"NOTE",
					"NOTES",
					"INFO",
					"INFOS",
					"HINT",
					"HINTS",
				},
			})
		end

		local function comments_fixme()
			---@diagnostic disable-next-line: undefined-field
			sp.todo_comments({ keywords = { "FIXME", "FIXIT", "BUG", "BUGS" } })
		end

		local function vim_config_files()
			---@diagnostic disable-next-line: assign-type-mismatch
			sp.files({ cwd = vim.fn.stdpath("config") })
		end

		local function search_lines(pattern)
			sp.lines({
				pattern = pattern,
				matcher = { fuzzy = false },
				sort = { fields = { "idx" } },
				title = "Search Buffer",
				layout = {
					preset = "vscode",
					layout = { height = 0.25, width = 0.6 },
				},
			})
		end

		local function search_lines_cword()
			search_lines(vim.fn.expand("<cword>"))
		end

		-- Important pickers on control + key
		map("<C-b>", sp.buffers, "Buffers")
		map("<C-f>", sp.grep, "Grep")
		map("<C-g>", sp.grep_buffers, "Grep buffers")
		map("<C-l>", search_lines, "Search Buffer Lines")
		map("<C-p>", smart_picker, "Find files")

		-- Special things
		map("<F1>", sp.help, "Help Pages")
		map("<leader>,", sp.spelling, "Spelling")
		map_with_icon("<leader>D", "<Cmd>lua Snacks.dashboard()<CR>", "Dashboard", "󱥇")
		map_with_icon("<leader>E", sp.explorer, "Explorer", "")
		Snacks.toggle.zen():map("<leader>z")

		-- Fancy search stuff
		map("<leader>8", search_lines_cword, "Search Buffer Lines with Current Word")
		map("<leader>*", sp.grep_word, "Live grep (word or selection)", { "n", "x" })

		-- <leader>s namespace for various snacks pickers
		map('<leader>s"', sp.registers, "Registers")
		map("<leader>s/", sp.search_history, "Search History")
		map("<leader>sa", sp.autocmds, "Autocmds")
		map("<leader>sc", sp.command_history, "Command History")
		map("<leader>sC", sp.commands, "Commands")
		map("<leader>sd", sp.diagnostics, "Diagnostics")
		map("<leader>sD", sp.diagnostics_buffer, "Buffer Diagnostics")
		map("<leader>sh", sp.help, "Help Pages")
		map("<leader>sH", sp.highlights, "Highlights")
		map("<leader>si", sp.icons, "Icons")
		map("<leader>sj", sp.jumps, "Jumps")
		map("<leader>sk", sp.keymaps, "Keymaps")
		map("<leader>sl", sp.loclist, "Location List")
		map("<leader>sM", sp.man, "Man Pages")
		map("<leader>sm", sp.marks, "Marks")
		map("<leader>so", sp.colorschemes, "Colorschemes")
		map("<leader>sq", sp.qflist, "Quickfix List")
		map("<leader>sR", sp.resume, "Resume")
		map("<leader>su", sp.undo, "Undo History")
		map("<leader>sv", vim_config_files, "Vim Config Files")
		map("<leader>st", comments_todo, "TODO Comments")
		map("<leader>sT", comments_fixme, "FIXME Comments")

		local function quick_lsp()
			sp.lsp_symbols({ layout = { preset = "vscode", preview = "main" } })
		end

		-- LSP
		-- Remember to keep this in sync with the `omit` list of
		-- `lsp_zero.default_keymaps` in `lsp.lua`.
		map("gd", sp.lsp_definitions, "Goto Definitions")
		map("gD", sp.lsp_declarations, "Goto Declarations")
		map("gr", sp.lsp_references, "References")
		map("gi", sp.lsp_implementations, "Goto Implementations")
		map("gy", sp.lsp_type_definitions, "Goto Type Definitions")
		map("<leader>ss", sp.lsp_symbols, "LSP Symbols")
		map("<leader>sS", sp.lsp_workspace_symbols, "LSP Workspace Symbols")
		map("<leader><leader>", quick_lsp, "Quick LSP Symbols")

		--- Toggles (using <leader>t namespace) ----------------------------------------

		Snacks.toggle.option("spell", { name = "󰓆 Spell" }):map("<leader>ts")
		Snacks.toggle.option("wrap", { name = "󰖶 Wrap" }):map("<leader>tw")
		Snacks.toggle.option("list", { name = "󱁐 List" }):map("<leader>tl")
		Snacks.toggle.diagnostics({ name = " Diagnostics" }):map("<leader>tD")
		Snacks.toggle.treesitter({ name = " Treesitter Highlight" }):map("<leader>tt")

		Snacks.toggle
			.new({
				id = "diag_virtual_text",
				name = " Diagnostics Virtual Text",
				get = function()
					---@diagnostic disable-next-line: return-type-mismatch
					return vim.diagnostic.config().virtual_text
				end,
				set = function(state)
					vim.diagnostic.config({ virtual_text = state })
				end,
			})
			:map("<leader>tv")

		Snacks.toggle
			.new({
				id = "git_blame",
				name = " Git Blame",
				get = function()
					return require("gitsigns.config").config.current_line_blame
				end,
				set = function(state)
					require("gitsigns").toggle_current_line_blame(state)
				end,
			})
			:map("<leader>tb")

		Snacks.toggle
			.new({
				id = "git_sign_column",
				name = " Git Sign Column",
				get = function()
					return require("gitsigns.config").config.signcolumn
				end,
				set = function(state)
					require("gitsigns").toggle_signs(state)
				end,
			})
			:map("<leader>tg")

		Snacks.toggle
			.new({
				id = "number",
				name = " Line Numbers",
				get = function()
					return vim.wo.number
				end,
				set = function(state)
					if state then
						vim.wo.relativenumber = false
					end
					vim.wo.number = state
				end,
			})
			:map("<leader>tn")

		Snacks.toggle
			.new({
				id = "relativenumber",
				name = " Relative Line Numbers",
				get = function()
					return vim.wo.relativenumber
				end,
				set = function(state)
					if state then
						vim.wo.number = false
					end
					vim.wo.relativenumber = state
				end,
			})
			:map("<leader>tN")

		Snacks.toggle
			.new({
				id = "format_on_save",
				name = "󰊄 Format on Save (global)",
				get = function()
					return not vim.g.disable_autoformat
				end,
				set = function(state)
					vim.g.disable_autoformat = not state
				end,
			})
			:map("<leader>tf")

		Snacks.toggle
			.new({
				id = "format_on_save_buffer",
				name = "󰊄 Format on Save (buffer)",
				get = function()
					return not vim.b.disable_autoformat
				end,
				set = function(state)
					vim.b.disable_autoformat = not state
				end,
			})
			:map("<leader>tF")

		Snacks.toggle
			.new({
				id = "copilot",
				name = " Copilot",
				get = function()
					return require("copilot-status").is_enabled()
				end,
				set = function(state)
					if state then
						vim.cmd("Copilot enable")
					else
						vim.cmd("Copilot disable")
					end
				end,
			})
			:map("<leader>tc")

		Snacks.toggle
			.new({
				id = "dim",
				name = "󰱊 Dimming",
				get = function()
					return Snacks.dim.enabled
				end,
				set = function(state)
					if state then
						Snacks.dim.enable()
					else
						Snacks.dim.disable()
					end
				end,
			})
			:map("<leader>td")

		Snacks.toggle
			.new({
				id = "foldcolumn",
				name = " Fold Column",
				get = function()
					return vim.o.foldcolumn ~= "0"
				end,
				set = function(state)
					vim.o.foldcolumn = state and "1" or "0"
				end,
			})
			:map("<leader>tC")
	end,
}
