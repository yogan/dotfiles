require("gitsigns").setup({
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Actions
		map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "git: stage hunk" })
		map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "git: reset hunk" })
		map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "git: undo stage hunk" })
		map("n", "<leader>gS", gs.stage_buffer, { desc = "git: stage file" })
		map("n", "<leader>gR", gs.reset_buffer, { desc = "git: reset file" })
		map("n", "<leader>gp", gs.preview_hunk, { desc = "git: diff hunk" })
		map("n", "<leader>gd", gs.diffthis, { desc = "git: diff file" })
		map("n", "<leader>gD", function()
			gs.diffthis("~")
		end, { desc = "git: diff file (staged)" })
		-- toggle line blame
		map("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "git: toggle blame" })
		map("n", "<leader>gB", function()
			gs.blame_line({ full = true })
		end, { desc = "git: blame popup" })

		-- Toggles
		map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "git: toggle blame" })
		map("n", "<leader>td", gs.toggle_deleted, { desc = "git: toggle deleted" })

		-- Text object (e.g. vig -> select current hunk)
		map({ "o", "x" }, "ig", ":<C-U>Gitsigns select_hunk<CR>", { desc = "git: select hunk" })

		-- NOTE: there are also gitsigns mappings in treesitter-textobjects.lua
		-- (navigation between hunks, made repeatable via ts-to)
	end,
})
