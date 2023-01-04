local color_scheme = "catppuccin" --"gruvbox"

function GruvBoxSetup()
	vim.g.gruvbox_contrast_dark = "soft"
	vim.g.tokyonight_transparent_sidebr = true
	vim.g.tokyonight_transparent = true
	vim.g.gruvbox_invert_selection = "0"
	vim.opt.background = "dark"
end

function CatppuccinSetup()
	vim.g.catppuccin_flavour = "mocha"
	require("catppuccin").setup()
end

if color_scheme == "poimandres" then
	PoimandresSetup()
end

if color_scheme == "catppuccin" then
	CatppuccinSetup()
end

if color_scheme == "tokyonight" then
	TokyonightSetup()
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

hl("netrwDir", {
	fg = "#5eacd3",
})

hl("Normal", {
	bg = "none",
})
