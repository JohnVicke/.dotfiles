local nvim_tree = require('nvim-tree')
local nnoremap = require("johnvicke.keymap").nnoremap

vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

nvim_tree.setup({
  open_on_setup = true,
})


nnoremap("<C-b>", function() nvim_tree.toggle(false, true) end)
