return {
	-- https://github.com/redhat-developer/yaml-language-server#language-server-settings
	settings = {
		yaml = {
			keyOrdering = false,
			schemaStore = {
				enable = true,
				url = "https://www.schemastore.org/api/json/catalog.json",
			},
			customTags = { "!reference sequence" },
			format = {
				singleQuote = true,
			},
		},
	},
}
