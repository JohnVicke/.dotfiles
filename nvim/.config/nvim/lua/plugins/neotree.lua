return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = true,
      window = {
        position = "float",
      },
    },
    keys = {
      { "<leader>neotree", "<Cmd>Neotree reveal toggle<CR>", desc = "Toggle NeoTree" },
    },
  },
}
