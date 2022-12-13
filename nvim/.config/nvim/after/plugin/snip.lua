local inoremap = require("johnvicke.keymap").inoremap

local ls = require("luasnip")

ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	enable_auto_snippets = true,
})

require("luasnip.loaders.from_snipmate").lazy_load({ paths = { "./snippets" } })

inoremap("<c-k>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end, { noremap = true, silent = true })

inoremap("<c-j>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump(-1)
	end
end, { noremap = true, silent = true })
