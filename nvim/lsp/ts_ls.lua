local commonSettings = {
	inlayHints = {
		includeInlayParameterNameHints = "literals",
		includeInlayParameterNameHintsWhenArgumentMatchesName = false,
		includeInlayFunctionParameterTypeHints = true,
		includeInlayVariableTypeHints = true,
		includeInlayVariableTypeHintsWhenTypeMatchesName = false,
		includeInlayPropertyDeclarationTypeHints = true,
		includeInlayFunctionLikeReturnTypeHints = true,
		includeInlayEnumMemberValueHints = true,
	},
	referencesCodeLens = { enabled = true, showOnAllFunctions = false },
	implementationsCodeLens = { enabled = false },
}

return { settings = { typescript = commonSettings, javascript = commonSettings } }

