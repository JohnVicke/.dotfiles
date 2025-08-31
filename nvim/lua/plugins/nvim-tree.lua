return {
  "kyazdani42/nvim-tree.lua",
  dependencies = {
    "kyazdani42/nvim-web-devicons",
  },
  lazy = false,
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Find file in filetree" },
  },
  opts = {
    filters = {
      custom = { ".git", "node_modules", ".vscode" },
      dotfiles = true,
    },
    git = {},
    view = {
      adaptive_size = true,
      float = {
        enable = true,
      },
    },
  },
}
