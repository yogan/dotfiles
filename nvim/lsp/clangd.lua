return {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		-- to fix this warning:
		-- multiple different client offset_encodings detected for buffer, this is not supported yet
		"--offset-encoding=utf-16",
	},
}

