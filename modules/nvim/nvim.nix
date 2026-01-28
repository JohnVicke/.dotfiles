{
  config,
  pkgs,
  ...
}: let
  plenary = pkgs.vimPlugins.plenary-nvim;
  vague-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "vague.nvim";
    version = "2024-09-06";
    src = pkgs.fetchFromGitHub {
      owner = "vague-theme";
      repo = "vague.nvim";
      rev = "fcc283576764474ccfbbcca240797d5d7f4d8a78";
      sha256 = "sha256-upqvTAnmJBAIoyzGxv+hq04dvS5wv3bjkbx2pWLCp+s=";
    };
  };
  harpoon2 = pkgs.vimUtils.buildVimPlugin {
    pname = "harpoon";
    version = "2025-02-10";
    buildInputs = [plenary];
    #  > Require check failed for the following modules:
    #  >   - harpoon.scratch.toggle
    doCheck = false;
    src = pkgs.fetchFromGitHub {
      owner = "ThePrimeagen";
      repo = "harpoon";
      rev = "ed1f853847ffd04b2b61c314865665e1dadf22c7";
      sha256 = "1dcpdlna2lff9dlsh6i4v16qmn5r9279wdvn0ry3xg4abqwnzc9g";
    };
  };
  dadbod = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-dadbod";
    version = "2025-16-12";
    src = pkgs.fetchFromGitHub {
      owner = "tpope";
      repo = "vim-dadbod";
      rev = "e95afed23712f969f83b4857a24cf9d59114c2e6";
      sha256 = "c933e16bafddeb60d0d0cd77253ef45ffb339163bcee88b0d32e0bf771432ead";
    };
  };
  dadbod-completion = pkgs.vimUtils.buildVimPlugin {
    pname = "dadbod-completion";
    version = "2025-16-12";
    src = pkgs.fetchFromGitHub {
      owner = "kristijanhusak";
      repo = "vim-dadbod-completion";
      rev = "a8dac0b3cf6132c80dc9b18bef36d4cf7a9e1fe6";
      sha256 = "17e6c2ae0ad1c8db6069fc0c4a39040558f72c2065c4564a6a3305d0afb1f03f";
    };
  };
  dadbod-ui = pkgs.vimUtils.buildVimPlugin {
    pname = "dadbod-ui";
    version = "2025-16-12";
    src = pkgs.fetchFromGitHub {
      owner = "kristijanhusak";
      repo = "vim-dadbod-ui";
      rev = "48c4f271da13d380592f4907e2d1d5558044e4e5";
      sha256 = "d12f4ce0e1ff871617be9592378f6f012ad66d833e4975a4484bddb7b81b394a";
    };
  };
in {
  home.packages = with pkgs; [
    lua-language-server
    typescript-language-server
    gopls
    tailwindcss-language-server
    vscode-js-debug
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;

    extraLuaConfig = ''
      ${builtins.readFile ./lua/util.lua}
      ${builtins.readFile ./lua/settings.lua}
    '';

    # available plugins: https://github.com/NixNeovim/NixNeovimPlugins/blob/main/plugins.md
    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = builtins.readFile ./lua/treesitter.lua;
      }
      {
        plugin = luasnip;
        type = "lua";
        config = builtins.readFile ./lua/luasnip.lua;
      }
      {
        plugin = fzf-lua;
        type = "lua";
        config = builtins.readFile ./lua/fzf.lua;
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./lua/lsp.lua;
      }
      {
        plugin = none-ls-nvim;
        type = "lua";
        config = builtins.readFile ./lua/none.lua;
      }
      {
        plugin = blink-cmp;
        type = "lua";
        config = builtins.readFile ./lua/blink.lua;
      }
      {
        plugin = copilot-lua;
        type = "lua";
        config = builtins.readFile ./lua/copilot.lua;
      }
      {
        plugin = vague-nvim;
        type = "lua";
        config = ''
          vim.cmd.colorscheme("vague")
        '';
      }
      {
        plugin = oil-nvim;
        type = "lua";
        config = builtins.readFile ./lua/oil.lua;
      }
      {
        plugin = plenary;
      }
      {
        plugin = harpoon2;
        type = "lua";
        config = builtins.readFile ./lua/harpoon.lua;
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = builtins.readFile ./lua/gitsigns.lua;
      }
      {
        plugin = tsc-nvim;
        type = "lua";
        config = builtins.readFile ./lua/tsc.lua;
      }
      {
        plugin = dadbod;
        type = "lua";
        config = builtins.readFile ./lua/dadbod.lua;
      }
      {
        plugin = dadbod-completion;
      }
      {
        plugin = dadbod-ui;
      }
      # DAP (Debug Adapter Protocol)
      nvim-nio
      nvim-dap
      nvim-dap-virtual-text
      {
        plugin = nvim-dap-ui;
        type = "lua";
        config = builtins.readFile ./lua/dap.lua;
      }
    ];
  };
}
