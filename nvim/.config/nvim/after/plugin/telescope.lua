local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

local nnoremap = require("johnvicke.keymap").nnoremap

function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

require("telescope").setup({
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close,
        ["<S-Enter>"] = actions.select_tab
      },
    },
  },
})



nnoremap("<leader>ff",  function() builtin.find_files() end)
nnoremap("<C-p>",       function() builtin.find_files() end)
nnoremap("<leader>fg",  function() builtin.live_grep() end)

