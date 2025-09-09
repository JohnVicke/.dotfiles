return {
  "stevearc/oil.nvim",
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  keys = {
    { "<leader>e", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  lazy = false,
}
