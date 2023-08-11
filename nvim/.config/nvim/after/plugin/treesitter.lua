require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"css",
		"graphql",
		"html",
		"javascript",
		"json",
		"lua",
		"python",
		"rust",
		"svelte",
		"tsx",
		"typescript",
		"markdown",
		"astro",
	},
	highlight = { enable = true },
})

vim.filetype.add({
	extension = {
		astro = "astro",
	},
})
