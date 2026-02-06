{pkgs, ...}: let
  directions = {
    h = "l"; # left
    j = "d"; # down
    k = "u"; # up
    l = "r"; # right
  };

  mod = "$mod";
  shiftMod = "$mod SHIFT";

  focusBinds = builtins.attrValues (
    builtins.mapAttrs (key: dir: "bind = ${mod}, ${key}, movefocus, ${dir}") directions
  );

  moveBinds = builtins.attrValues (
    builtins.mapAttrs (key: dir: "bind = ${shiftMod}, ${key}, movewindow, ${dir}") directions
  );
in {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mod" = "SUPER";

      bind =
        [
          "$mod, SPACE, exec, ${pkgs.fuzzel}/bin/fuzzel"
          "$mod, return, exec, ghostty"
          "$mod, ESCAPE, exec, ${pkgs.hyprlock}/bin/hyprlock"

          "$mod SHIFT, return, exec, zen-beta"
          "$mod SHIFT, Q, killactive"
          "$mod, F, fullscreen"
        ]
        ++ (builtins.concatLists (
          builtins.genList (
            i: let
              ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9
        ))
        ++ focusBinds
        ++ moveBinds;

      input = {
        kb_layout = "se";
        kb_options = "compose:caps";
        repeat_rate = 40;
        repeat_delay = 600;

        touchpad = {
          scroll_factor = 0.4;
          natural_scroll = true;
          clickfinger_behavior = true;
        };

        sensitivity = -0.5;
      };

      decoration = {
        rounding = 10;
      };
    };
  };
}
