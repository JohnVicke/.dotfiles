return {
  "telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      version = "^1.0.0",
    },
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    config = function()
      local telescope = require("telescope")
      telescope.load_extension("fzf")
      telescope.load_extension("live_grep_args")
    end,
  },
}
