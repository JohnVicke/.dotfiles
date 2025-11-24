{ config, pkgs, ... }:

let
  plenary = pkgs.vimPlugins.plenary-nvim;
  vague-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "vague.nvim";
    version = "2024-09-06";
    src = pkgs.fetchFromGitHub {
      owner = "vague2k";
      repo = "vague.nvim";
      rev = "main";
      sha256 = "10cq9rd1ls9zcqbgq29yxycidsksk068mh6sxdw1w90l15xvl1ka";
    };
  };
  harpoon2 = pkgs.vimUtils.buildVimPlugin {
    pname = "harpoon";
    version = "2025-02-10";
    buildInputs = [ plenary ];
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
in
{
  home.packages = with pkgs; [
    lua-language-server
    typescript-language-server
    gopls
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

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
    ];
  };
}
