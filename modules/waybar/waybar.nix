{
  programs = {
    waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 26;
          modules-left = [
            "hyprland/workspaces"
          ];
          modules-center = [
            "clock"
            "custom/update"
          ];
          modules-right = [
            "group/tray-expander"
            "bluetooth"
            "network"
            "pulseaudio"
            "cpu"
            "battery"
          ];
          "hyprland/workspaces" = {
            format = "{icon}";
            format-icons = {
              default = "";
              "1" = "1";
              "2" = "2";
              "3" = "3";
              "4" = "4";
              "5" = "5";
              "6" = "6";
              "7" = "7";
              "8" = "8";
              "9" = "9";
              "active" = "󱓻";
            };
            persistent-workspaces = {
              "1" = "[]";
              "2" = "[]";
              "3" = "[]";
              "4" = "[]";
            };
          };
        };
      };
      style = ./waybar.css;
    };
  };
}
