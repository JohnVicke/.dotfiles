local color_scheme = "solarized-osaka" -- "catppuccin" --"github_dark_default" -- "github_dark" -- "gruvbox"

function GruvBoxSetup()
	vim.g.gruvbox_contrast_dark = "soft"
	vim.g.tokyonight_transparent_sidebr = true
	vim.g.tokyonight_transparent = true
	vim.g.gruvbox_invert_selection = "0"
	vim.opt.background = "dark"
end

function GithubSetup()
	require("github-theme").setup({
		theme_style = "dark_default",
		function_style = "italic",
		sidebars = { "qf", "vista_kind", "terminal", "packer" },

		-- Change the "hint" color to the "orange" color, and make the "error" color bright red
		colors = { hint = "orange", error = "#ff0000" },

		-- Overwrite the highlight groups
		overrides = function(c)
			return {
				htmlTag = { fg = c.red, bg = "#282c34", sp = c.hint, style = "underline" },
				DiagnosticHint = { link = "LspDiagnosticsDefaultHint" },
				-- this will remove the highlight groups
				TSField = {},
			}
		end,
	})
end

function CatppuccinSetup()
	vim.g.catppuccin_flavour = "mocha"
	require("catppuccin").setup()
end

if color_scheme == "catppuccin" then
	CatppuccinSetup()
end

if color_scheme == "github_dark" then
	GithubSetup()
end

if color_scheme == "gruvbox" then
	GruvBoxSetup()
end

vim.g.johnvicke_colorscheme = color_scheme
vim.cmd("colorscheme " .. vim.g.johnvicke_colorscheme)
vim.opt.signcolumn = "yes"

local hl = function(thing, opts)
	vim.api.nvim_set_hl(0, thing, opts)
end

hl("LineNr", {
	fg = "#6c7086",
})
