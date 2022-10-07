local m = require("johnvicke.keymap")

m.inoremap("jj", "<ESC>")
m.nnoremap("<leader>q", ":q<CR>")
m.nnoremap("<leader>x", ":qa<CR>")
m.nnoremap("<leader>w", ":w<CR>")
m.nnoremap("<leader>y", '"+y')
m.vnoremap("<leader>y", '"+y')
