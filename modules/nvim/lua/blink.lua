require("blink.cmp").setup({
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 500,
		}
	},
	keymap = {
		preset = "default",
		["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },
	},
	snippets = { preset = "luasnip" },
	sources = {
		default = { "lsp", "path", "snippets", "buffer", "omni" },
		providers = {
			lsp      = { name = "LSP",  score_offset = 40 },
			path     = { name = "Path", score_offset = 50 },
			snippets = { name = "Snip", score_offset = 40 },
			buffer   = { name = "Buffer" },
			omni     = { name = "Omni" },
		},
	},
	cmdline = {
		enabled = true,
		completion = {
			menu = {
				auto_show = true,
			},
		},
		sources = function()
			local type = vim.fn.getcmdtype()
			if type == '/' or type == '?' then return { 'buffer' } end
			if type == ':' or type == '@' then return { 'cmdline' } end
			return {}
		end,
	},
	signature = {
		enabled = true,
		window = {
			show_documentation = true,
		},
	},
})
