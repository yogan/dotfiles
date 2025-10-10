return {
	-- https://github.com/redhat-developer/yaml-language-server#language-server-settings
	settings = {
		yaml = {
			-- disable built-in schemaStore, use schemastore.nvim instead
			schemaStore = { enable = false, url = "" },
			schemas = require("schemastore").yaml.schemas(),

			customTags = { "!reference sequence" },
			format = { singleQuote = true },
			keyOrdering = false,
		},
	},
}
