{ config, pkgs, ...}:

let
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
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = ''
      ${builtins.readFile ./lua/util.lua}
      ${builtins.readFile ./lua/settings.lua}
    '';

    plugins = with pkgs.vimPlugins; [
		   {
				 plugin = nvim-treesitter.withAllGrammars;
				 type = "lua";
				 config = builtins.readFile ./lua/treesitter.lua;
      }
      {
        plugin = vague-nvim;
        type = "lua";
        config = ''
          vim.cmd.colorscheme("vague")
        '';
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ./lua/telescope.lua;
      }
      {
        plugin = oil-nvim;
        type = "lua";
        config = builtins.readFile ./lua/oil.lua;
      }
    ];

		extraPackages = with pkgs; [
			lua-language-server
			nodePackages.typescript-language-server
		];
  };
}
