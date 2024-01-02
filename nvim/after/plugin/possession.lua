-- To exclude hidden buffers, see:
-- https://github.com/jedrzejboczar/possession.nvim#session-options
vim.opt.sessionoptions:remove("buffers")

require("possession").setup({
	silent = true,
	load_silent = true,
	autosave = {
		current = true,
		tmp = false,
		on_load = true,
		on_quit = true,
	},
	commands = {
		save = "SessionSave",
		load = "SessionLoad",
		close = "SessionClose",
		delete = "SessionDelete",
		show = "SessionShow",
		list = "SessionList",
		migrate = "SessionMigrate",
	},
})

local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
	telescope.load_extension("possession")
	-- shift S to not clash with ps… (symbols) mappings
	-- also: ^A S brings up tmux session switcher, so consistency and all…
	vim.keymap.set("n", "<leader>pS", telescope.extensions.possession.list, { desc = "Load session" })
end
