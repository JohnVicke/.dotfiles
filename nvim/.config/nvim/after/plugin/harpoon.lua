local nnoremap     = require("johnvicke.keymap").nnoremap
local harpoon_mark = require("harpoon.mark")
local harpoon      = require("harpoon")
local harpoon_io   = require("harpoon.ui")

nnoremap("<leader>ho", function() harpoon_io.toggle_quick_menu() end)
nnoremap("<leader>ha", function() harpoon_mark.add_file() end)
nnoremap("<leader>a",  function() harpoon_io.nav_file(1) end)
nnoremap("<leader>s",  function() harpoon_io.nav_file(2) end)
nnoremap("<leader>d",  function() harpoon_io.nav_file(3) end)
nnoremap("<leader>f",  function() harpoon_io.nav_file(4) end)

harpoon.setup {}