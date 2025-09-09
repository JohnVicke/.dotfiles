{ config, pkgs, ...}:

{
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
        plugin = rose-pine;
        type = "lua";
        config = ''
          vim.cmd.colorscheme("rose-pine")
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
  };
}
