local tc = require("treesitter-context")

tc.setup({
	max_lines = 8,
	multiline_threshold = 3,
})

vim.keymap.set("n", "[a", function()
	tc.go_to_context(vim.v.count1)
end, { silent = true, desc = "Go to outer context (at level <count>)" })
