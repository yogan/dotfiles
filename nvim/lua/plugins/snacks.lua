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
	local function cursor_blend(value)
		local hl = vim.api.nvim_get_hl(0, { name = "Cursor", create = true })
		hl.blend = value

		---@diagnostic disable-next-line: param-type-mismatch
		vim.api.nvim_set_hl(0, "Cursor", hl)
		vim.cmd("set guicursor+=a:Cursor/lCursor")
	end

	-- required for initial dashboard, BufEnter is too late
	vim.api.nvim_create_autocmd("User", {
		pattern = "SnacksDashboardOpened",
		callback = function()
			cursor_blend(100)
			vim.opt_local.fillchars:append("eob: ")
		end,
		once = true,
	})

	-- required for re-opening the dashboard later
	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function()
			if vim.bo.filetype == "snacks_dashboard" then
				cursor_blend(100)
			end
		end,
	})

	-- make cursor visible again when leaving the dashboard
	vim.api.nvim_create_autocmd("BufLeave", {
		callback = function()
			if vim.bo.filetype == "snacks_dashboard" then
				cursor_blend(0)
			end
		end,
	})
end

return {
	"folke/snacks.nvim",
	priority = 1000,
	dependencies = {
		"folke/persistence.nvim",
		"folke/which-key.nvim",
	},
	---@type snacks.plugins.Config
	opts = {
		bigfile = { enabled = true },

		-- See https://github.com/folke/snacks.nvim/discussions/111 for a lot of
		-- cool dashboard setups.
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
					ttl = 0, -- disable cache (~/.cache/nvim/snacks), as it gets
					--          very large pretty fast due to the animations
					height = 11,
					width = 69,
					indent = -5,
				},
				{ section = "keys", indent = 2, padding = 2, gap = 1 },
				{ section = "startup", padding = 2 },
			},
		},

		notifier = {
			enabled = true,
			level = vim.log.levels.INFO,
			margin = { top = 1, right = 1, bottom = 1 },
			top_down = false,
		},

		picker = {
			enabled = true,

			win = {
				input = {
					bo = { textwidth = 0 },
					keys = {
						-- Make ^U work as usual in insert mode (clear line).
						-- In normal mode, and when list or preview has focus,
						-- ^U will still scroll up.
						["<C-u>"] = { "<C-u>", mode = { "i" }, expr = true },
						-- Add Alt+U as alternative to scroll up half a page.
						["<M-u>"] = { "list_scroll_up", mode = { "i", "n" } },
					},
				},
				preview = {
					wo = {
						number = false,
						spell = false,
						wrap = false,
						statuscolumn = "",
					},
				},
			},
		},

		scratch = {
			enabled = true,
			ft = "markdown",
		},

		statuscolumn = { enabled = true },

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
		local sr = require("snacks.rename")
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

		-- NOTE: keep in sync with definitions in todo-comments.lua
		local function comments_todo()
			---@diagnostic disable-next-line: undefined-field
			sp.todo_comments({
				-- concatenation hacks to avoid being detected here
				keywords = {
					"F" .. "IXME",
					"F" .. "IXIT",
					"B" .. "UG",
					"B" .. "UGS",
					"W" .. "ARNING",
					"W" .. "ARNINGS",
					"A" .. "TTENTION",
					"T" .. "ODO",
					"T" .. "ODOS",
					"I" .. "SSUE",
					"I" .. "SSUES",
					"N" .. "OTE",
					"N" .. "OTES",
					"I" .. "NFO",
					"I" .. "NFOS",
					"H" .. "INT",
					"H" .. "INTS",
				},
			})
		end

		local function comments_fixme()
			---@diagnostic disable-next-line: undefined-field
			sp.todo_comments({
				-- concatenation hacks to avoid being detected here
				keywords = {
					"F" .. "IXME",
					"F" .. "IXIT",
					"B" .. "UG",
					"B" .. "UGS",
				},
			})
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

		-- Important pickers on control + key
		map("<C-b>", sp.buffers, "Buffers")
		map("<C-f>", function() sp.grep({ hidden = true }) end, "Grep")
		map("<C-g>", sp.grep_buffers, "Grep Buffers")
		map("<C-l>", search_lines, "Search Buffer Lines")
		map("<C-p>", function() sp.files({ hidden = true }) end, "Find Files")

		-- Special things
		map("<F1>", sp.help, "Help Pages")
		map("<leader>,", sp.spelling, "Spelling Corrections")
		map_with_icon("<leader>D", "<Cmd>lua Snacks.dashboard()<CR>", "Dashboard", "󱝁")
		map_with_icon("<leader>E", sp.explorer, "Explorer", "")
		Snacks.toggle.zen():map("<leader>z")

		-- Fancy search stuff
		map("<leader>8", function() search_lines(vim.fn.expand("<cword>")) end, "Search Buffer Lines with Current Word")
		map("<leader>*", sp.grep_word, "Live grep (word or selection)", { "n", "x" })

		-- <leader>s namespace for various snacks pickers
		map("<leader>s/", sp.search_history, "Search History")
		map("<leader>sa", sp.autocmds, "Autocmds")
		map("<leader>sc", sp.command_history, "Command History")
		map("<leader>sC", sp.commands, "Commands")
		map("<leader>sd", sp.diagnostics, "Diagnostics")
		map("<leader>sD", sp.diagnostics_buffer, "Buffer Diagnostics")
		map("<leader>sf", function() sp.files({ hidden = true }) end, "Find Files")
		map("<leader>sg", function() sp.git_files({ hidden = true }) end, "Git Files")
		map("<leader>sh", sp.help, "Help Pages")
		map("<leader>sH", sp.highlights, "Highlights")
		map("<leader>si", sp.icons, "Icons")
		map("<leader>sj", sp.jumps, "Jumps")
		map("<leader>sk", sp.keymaps, "Keymaps")
		map("<leader>sM", sp.man, "Man Pages")
		map("<leader>sm", sp.marks, "Marks")
		map("<leader>sn", function() require("snacks.notifier").show_history({ reverse = false }) end, "Notifications")
		map("<leader>so", sp.colorschemes, "Colorschemes")
		map("<leader>sp", sp.pickers, "Pickers")
		map("<leader>sQ", sp.loclist, "Location List")
		map("<leader>sq", sp.qflist, "Quickfix List")
		map("<leader>sr", sp.recent, "Recent Files")
		map("<leader>sR", sr.rename_file, "Rename File")
		map("<leader>sS", function() sp.smart({ hidden = true }) end, "Smart Find Files")
		map("<leader>ss", sp.resume, "Resume Last Picker")
		map("<leader>sT", comments_fixme, "F" .. "IXME Comments")
		map("<leader>st", comments_todo, "T" .. "ODO Comments")
		map("<leader>su", sp.undo, "Undo History")
		map("<leader>sv", vim_config_files, "Vim Config Files")
		map('<leader>s"', sp.registers, "Registers")

		-- LSP
		map("gd", sp.lsp_definitions, "Goto Definitions")
		map("gD", sp.lsp_declarations, "Goto Declarations")
		map("gl", sp.lsp_incoming_calls, "Incoming Calls")
		map("gL", sp.lsp_outgoing_calls, "Outgoing Calls")
		map("gr", sp.lsp_references, "References")
		map("gi", sp.lsp_implementations, "Goto Implementations")
		map("gy", sp.lsp_type_definitions, "Goto Type Definitions")
		map("<leader>sl", sp.lsp_symbols, "LSP Symbols")
		map("<leader>sL", sp.lsp_workspace_symbols, "LSP Workspace Symbols")
		map(
			"<leader><leader>",
			function() sp.lsp_symbols({ layout = { preset = "vscode", preview = "main" } }) end,
			"Quick LSP Symbols"
		)

		-- Scratch buffer ----------------------------------------------------------------

		map("<leader>.", function() Snacks.scratch() end, "Toggle Scratch Buffer")
		map("<leader>sb", function() Snacks.scratch.select() end, "Select Scratch Buffer")

		--- Toggles (using <leader>t namespace) -----------------------------------------

		Snacks.toggle.option("spell", { name = "󰓆 Spell Checking" }):map("<leader>ts")
		Snacks.toggle.option("wrap", { name = "󰖶 Wrap Long Lines" }):map("<leader>tw")
		Snacks.toggle.option("list", { name = "󱁐 List (Visible Whitespace)" }):map("<leader>tl")
		Snacks.toggle.diagnostics({ name = " Diagnostics" }):map("<leader>tD")
		Snacks.toggle.treesitter({ name = " Treesitter Highlighting" }):map("<leader>tt")

		Snacks.toggle
			.new({
				id = "diag_virtual_text",
				name = " Diagnostics Virtual Text",
				get = function() return vim.diagnostic.config().virtual_text ~= false end,
				set = function(state)
					require("tiny-inline-diagnostic").toggle()
					if state then
						-- NOTE: keep in sync with default in `lsp.lua`
						vim.diagnostic.config({
							virtual_text = { prefix = "", spacing = 2 },
						})
					else
						vim.diagnostic.config({ virtual_text = false })
					end
				end,
			})
			:map("<leader>tv")

		Snacks.toggle
			.new({
				id = "git_blame",
				name = " Git Blame",
				get = function() return require("gitsigns.config").config.current_line_blame end,
				set = function(state) require("gitsigns").toggle_current_line_blame(state) end,
			})
			:map("<leader>tb")

		Snacks.toggle
			.new({
				id = "git_sign_column",
				name = " Git Sign Column",
				get = function() return require("gitsigns.config").config.signcolumn end,
				set = function(state) require("gitsigns").toggle_signs(state) end,
			})
			:map("<leader>tg")

		Snacks.toggle
			.new({
				id = "number",
				name = " Line Numbers",
				get = function() return vim.wo.number end,
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
				get = function() return vim.wo.relativenumber end,
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
				get = function() return not vim.g.disable_autoformat end,
				set = function(state) vim.g.disable_autoformat = not state end,
			})
			:map("<leader>tf")

		Snacks.toggle
			.new({
				id = "format_on_save_buffer",
				name = "󰊄 Format on Save (buffer)",
				get = function() return not vim.b.disable_autoformat end,
				set = function(state) vim.b.disable_autoformat = not state end,
			})
			:map("<leader>tF")

		Snacks.toggle
			.new({
				id = "copilot",
				name = " Copilot",
				get = function() return require("copilot-status").is_enabled() end,
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
				id = "copilot_buffer",
				name = " Copilot (buffer)",
				get = function() return vim.b.copilot_enabled end,
				set = function(state) vim.b.copilot_enabled = state end,
			})
			:map("<leader>tC")

		Snacks.toggle
			.new({
				id = "dim",
				name = "󰱊 Dimming",
				get = function() return Snacks.dim.enabled end,
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
				id = "inline_hints",
				name = " LSP Inline Hints",
				get = vim.lsp.inlay_hint.is_enabled,
				set = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
			})
			:map("<leader>ti")

		Snacks.toggle
			.new({
				id = "inline_hints_end",
				name = " LSP Inline Hints at Line End",
				get = function() return vim.g.snacks_toggle_lsp_hints_end end,
				set = function()
					require("lsp-endhints").toggle()
					vim.g.snacks_toggle_lsp_hints_end = not vim.g.snacks_toggle_lsp_hints_end
				end,
			})
			:map("<leader>tI")

		Snacks.toggle
			.new({
				id = "render_markdown",
				name = " Render Markdown",
				get = function() return require("render-markdown").get() end,
				set = function(state) require("render-markdown").set(state) end,
			})
			:map("<leader>tm")
	end,
}
