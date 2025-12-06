-- Julia LSP is always a major pain in the ass to get working
--
-- Those article say to have to put a crazy cmd = {} below:
--   https://discourse.julialang.org/t/julia-lsp-in-neovim-0-11/129048/2
--   https://www.andersevenrud.net/neovim.github.io/lsp/configurations/julials/
--   https://github.com/rafserqui/dot-files/blob/8afc53f5afb60cad155ab49bab94dc919c1dbefe/nvim/lua/user/lsp_julia.lua#L4
-- It seems to work without that, though. Startup is slow, but that is also the
-- case with the cmd. At least formatting and renaming works.
--
-- However, what was probably right was to do this:
--   julia -e 'using Pkg; Pkg.add("LanguageServer"); Pkg.add("SymbolServer")'

return {
	filetypes = { "julia" },
	root_markers = { "Project.toml", "Manifest.toml" },
	settings = {},
}
