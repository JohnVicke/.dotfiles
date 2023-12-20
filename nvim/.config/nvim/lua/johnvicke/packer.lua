return require("packer").startup(function()
	use("wbthomason/packer.nvim")

	use("nvim-treesitter/nvim-treesitter", {
		run = ":TSUpdate",
	})

	use("romgrk/nvim-treesitter-context")

	use("kyazdani42/nvim-web-devicons")

	use({ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } })

	use("f-person/git-blame.nvim")
	use({ "nvim-telescope/telescope-ui-select.nvim" })

	use("gruvbox-community/gruvbox")
	use({ "catppuccin/nvim", as = "catppuccin" })

	use("lewis6991/gitsigns.nvim")
	use("dinhhuy258/git.nvim")
	use({ "projekt0n/github-nvim-theme", tag = "v0.0.7" })
	use({ "craftzdog/solarized-osaka.nvim" })

	-- Telescope
	use("nvim-lua/plenary.nvim")
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
		},
		config = function()
			require("telescope").load_extension("live_grep_args")
		end,
	})

	use("ThePrimeagen/harpoon")

	use({
		"ThePrimeagen/refactoring.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	})

	use({ "zbirenbaum/copilot.lua" })

	use("neovim/nvim-lspconfig")

	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/nvim-cmp")
	use({ "L3MON4D3/LuaSnip" })
	use("saadparwaiz1/cmp_luasnip")
	use("onsails/lspkind-nvim")
	use("nvim-lua/lsp_extensions.nvim")
	use({
		"glepnir/lspsaga.nvim",
		config = function()
			require("lspsaga").setup({})
		end,
	})
	use("simrat39/symbols-outline.nvim")

	use({ "hrsh7th/cmp-cmdline" })
	use({ "hrsh7th/cmp-path" })
	use({ "hrsh7th/cmp-buffer" })
	use({ "hrsh7th/cmp-nvim-lsp" })
	use({ "onsails/lspkind-nvim" })
	use({ "hrsh7th/cmp-vsnip" })
	use({ "hrsh7th/vim-vsnip" })
	use({ "rafamadriz/friendly-snippets" })

	use({
		"hrsh7th/nvim-cmp",
		requires = {
			-- Cmdline completions
			"hrsh7th/cmp-cmdline",
			-- Path completions
			"hrsh7th/cmp-path",
			-- Buffer completions
			"hrsh7th/cmp-buffer",
			-- LSP completions
			"hrsh7th/cmp-nvim-lsp",
			"onsails/lspkind-nvim",
			-- vnsip completions
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
			"rafamadriz/friendly-snippets",
		},
	})

	use("princejoogie/tailwind-highlight.nvim")

	use("jose-elias-alvarez/null-ls.nvim")

	use({
		"creativenull/diagnosticls-configs-nvim",
	})

	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
	})

	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
	})

	use({ "williamboman/mason.nvim" })
	use({ "williamboman/mason-lspconfig.nvim" })
	use({ "WhoIsSethDaniel/mason-tool-installer.nvim" })

	use({
		"startup-nvim/startup.nvim",
		requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	})
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
	})
	use({ "tpope/vim-surround" })
	use({ "simrat39/rust-tools.nvim" })
	use({ "folke/which-key.nvim" })
end)
