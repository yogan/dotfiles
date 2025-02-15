local sp = require("snacks.picker")
local wk = require("which-key")

require("gitsigns").setup({
	on_attach = function(bufnr)
		local function map(mode, l, r, desc)
			wk.add({
				{ mode = mode, l, r, buffer = bufnr, desc = desc, icon = "" },
				group = "Git Signs",
			})
		end

		local gs = package.loaded.gitsigns

		local function diff_file_staged()
			gs.diffthis("~")
		end

		local function blame_popup()
			gs.blame_line({ full = true })
		end

		-- Actions
		map({ "n", "v" }, "<leader>ga", gs.stage_hunk, "Stage hunk")
		map({ "n", "v" }, "<leader>gr", gs.reset_hunk, "Reset hunk")
		map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
		map("n", "<leader>gA", gs.stage_buffer, "Stage file")
		map("n", "<leader>gR", gs.reset_buffer, "Reset file")
		map("n", "<leader>gg", gs.preview_hunk, "Diff hunk")
		map("n", "<leader>gd", gs.diffthis, "Diff file")
		map("n", "<leader>gD", diff_file_staged, "Diff file (staged)")
		map("n", "<leader>gb", blame_popup, "Blame popup")

		-- Text object (e.g. vig -> select current hunk)
		map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")

		-- NOTE: there are also gitsigns mappings in treesitter-textobjects.lua
		-- (navigation between hunks, made repeatable via ts-to)

		-- NOTE: snacks-toggles.lua also has two Gitsigns toggle mappings
	end,
})

-- Snack's Git stuff (put here to have all key mappings in one place):

local function map(l, r, desc)
	wk.add({
		{ mode = "n", l, r, desc = desc, icon = "" },
		group = "Snacks Git",
	})
end

map("<leader>gB", sp.git_branches, "Branches")
map("<leader>gl", sp.git_log, "Log")
map("<leader>gL", sp.git_log_line, "Log Line")
map("<leader>gk", sp.git_log_file, "Log File")
map("<leader>gs", sp.git_status, "Status")
map("<leader>gh", sp.git_stash, "Stash")
