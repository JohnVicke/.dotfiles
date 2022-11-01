return require("packer").startup(function()
  use "wbthomason/packer.nvim"


  use "kdheepak/lazygit.nvim" 

  use("nvim-treesitter/nvim-treesitter", {
        run = ":TSUpdate"
    })

  use("romgrk/nvim-treesitter-context")

  use("kyazdani42/nvim-web-devicons")


  use({"nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true }
    })
  
  use ("olivercederborg/poimandres.nvim")

  use("gruvbox-community/gruvbox")
  use("folke/tokyonight.nvim")
  use{ "catppuccin/nvim", as = "catppuccin"}

  use("lewis6991/gitsigns.nvim")
  use("dinhhuy258/git.nvim")

  -- Telescope
  use "nvim-lua/plenary.nvim"
  use "nvim-telescope/telescope.nvim"
  use { "nvim-telescope/telescope-file-browser.nvim" }

  use ("ThePrimeagen/harpoon")

  use {
    "ThePrimeagen/refactoring.nvim",
    requires = {
        {"nvim-lua/plenary.nvim"},
        {"nvim-treesitter/nvim-treesitter"}
    }
  }

  -- LSP stuff
  use "neovim/nvim-lspconfig"

  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/nvim-cmp")
  use({"L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*"})
  use("saadparwaiz1/cmp_luasnip")
  use("onsails/lspkind-nvim")
  use("nvim-lua/lsp_extensions.nvim")
  use("glepnir/lspsaga.nvim")
  use("simrat39/symbols-outline.nvim")

  use("jose-elias-alvarez/null-ls.nvim")

  use("sotte/presenting.vim")

end)

