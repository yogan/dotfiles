---@type vim.lsp.Config
return {
	-- The default is the Git root directory, but this breaks in my AoC
	-- solutions, where my Perl solutions are in a subdirectory.
	-- This might not be the right setting all the time, but there it works.
	root_dir = function(bufnr_, on_dir) on_dir(vim.fn.getcwd()) end,
}

