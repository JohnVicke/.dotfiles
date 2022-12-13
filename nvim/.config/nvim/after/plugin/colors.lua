local color_scheme = "catppuccin" --"gruvbox"

function PoimandresSetup()
	local hl = function(thing, opts)
		vim.api.nvim_set_hl(0, thing, opts)
	end

	hl("SignColumn", {
		bg = "none",
	})

	hl("ColorColumn", {
		ctermbg = 0,
		bg = "#555555",
	})

	hl("CursorLineNR", {
		bg = "None",
	})

	hl("LineNr", {
		fg = "#5eacd3",
	})

	hl("netrwDir", {
		fg = "#5eacd3",
	})
end

function GruvBoxSetup()
	vim.g.gruvbox_contrast_dark = "soft"
	vim.g.tokyonight_transparent_sidebr = true
	vim.g.tokyonight_transparent = true
	vim.g.gruvbox_invert_selection = "0"
	vim.opt.background = "dark"

	local hl = function(thing, opts)
		vim.api.nvim_set_hl(0, thing, opts)
	end

	hl("LineNr", {
		fg = "#5eacd3",
	})

	hl("netrwDir", {
		fg = "#5eacd3",
	})

	hl("Normal", {
		bg = "none",
	})
end

function CatppuccinSetup()
	require("catppuccin").setup({
		flavour = "mocha", -- latte, frappe, macchiato, mocha
		background = { -- :h background
			light = "latte",
			dark = "mocha",
		},
		transparent_background = true,
		term_colors = false,
		dim_inactive = {
			enabled = false,
			shade = "dark",
			percentage = 0.15,
		},
		no_italic = false, -- Force no italic
		no_bold = false, -- Force no bold
		styles = {
			comments = { "italic" },
			conditionals = { "italic" },
			loops = {},
			functions = {},
			keywords = {},
			strings = {},
			variables = {},
			numbers = {},
			booleans = {},
			properties = {},
			types = {},
			operators = {},
		},
		color_overrides = {},
		custom_highlights = {},
		integrations = {
			cmp = true,
			gitsigns = true,
			nvimtree = true,
			telescope = true,
			notify = false,
			mini = false,
			-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
		},
	})
	local hl = function(thing, opts)
		vim.api.nvim_set_hl(0, thing, opts)
	end

	hl("LineNr", {
		fg = "#5eacd3",
	})

	hl("netrwDir", {
		fg = "#5eacd3",
	})

	hl("Normal", {
		bg = "none",
	})
end

function TokyonightSetup()
	require("tokyonight").setup({
		-- your configuration comes here
		-- or leave it empty to use the default settings
		style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
		light_style = "day", -- The theme is used when the background is set to light
		transparent = false, -- Enable this to disable setting the background color
		terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
		styles = {
			-- Style to be applied to different syntax groups
			-- Value is any valid attr-list value for `:help nvim_set_hl`
			comments = { italic = true },
			keywords = { italic = true },
			functions = {},
			variables = {},
			-- Background styles. Can be "dark", "transparent" or "normal"
			sidebars = "dark", -- style for sidebars, see below
			floats = "dark", -- style for floating windows
		},
		sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
		day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
		hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
		dim_inactive = false, -- dims inactive windows
		lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

		--- You can override specific color groups to use other groups or a hex color
		--- function will be called with a ColorScheme table
		---@param colors ColorScheme
		on_colors = function(colors) end,

		--- You can override specific highlights to use other groups or a hex color
		--- function will be called with a Highlights and ColorScheme table
		---@param highlights Highlights
		---@param colors ColorScheme
		on_highlights = function(highlights, colors) end,
	})
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

GruvBoxSetup()
