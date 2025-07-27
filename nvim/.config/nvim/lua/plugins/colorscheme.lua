return {
  {
    "catppuccin/nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-frappe",
    },
  },
}

-- return {
--   {
--     "craftzdog/solarized-osaka.nvim",
--     lazy = true,
--     priority = 1000,
--     opts = function()
--       return {
--         transparent = true,
--       }
--     end,
--   },
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "solarized-osaka",
--     },
--   },
-- }
-- return {
--   "rose-pine/neovim",
--   name = "rose-pine",
--   config = function()
--     vim.cmd("colorscheme rose-pine")
--   end,
-- }
