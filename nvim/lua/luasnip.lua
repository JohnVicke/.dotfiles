local ls = require("luasnip")
ls.setup({ enable_autosnippets = true })
require("luasnip.loaders.from_lua").load({ paths = "~/.dotfiles/nvim/snippets/" })

inoremap("<C-s>", function() ls.expand_or_jump(1) end, { silent = true })
inoremap("<C-J>", function() ls.jump(1) end, { silent = true })
inoremap("<C-K>", function() ls.jump(-1) end, { silent = true })
