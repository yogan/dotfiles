local function helm_template(path)
	local chart = vim.fs.find("Chart.yaml", {
		path = vim.fs.dirname(path),
		upward = true,
		type = "file",
	})[1]
	if not chart then return end

	local templates = vim.fs.joinpath(vim.fs.dirname(chart), "templates") .. "/"
	if vim.startswith(vim.fs.normalize(path), templates) then return "helm" end
end

vim.filetype.add({
	extension = { mips = "mips" },
	pattern = {
		[".*/templates/.*%.yaml"] = helm_template,
		[".*/templates/.*%.yml"] = helm_template,
	},
})
