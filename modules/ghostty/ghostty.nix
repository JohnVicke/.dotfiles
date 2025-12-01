{
  config,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-family = "MonaspiceAr Nerd Font";
      theme = "vague";
    };
    package = pkgs.writeShellScriptBin "ghostty" ''
      exec ${pkgs.nixGL.nixGLIntel}/bin/nixGLIntel ${pkgs.ghostty}/bin/ghostty "$@"
    '';
    themes = {
      vague = {
        palette = [
          "0=#252530"
          "1=#d8647e"
          "2=#7fa563"
          "3=#f3be7c"
          "4=#6e94b2"
          "5=#bb9dbd"
          "6=#aeaed1"
          "7=#cdcdcd"
          "8=#606079"
          "9=#e08398"
          "10=#99b782"
          "11=#f5cb96"
          "12=#8ba9c1"
          "13=#c9b1ca"
          "14=#bebeda"
          "15=#d7d7d7"
        ];
        background = "#141415";
        foreground = "#cdcdcd";
        cursor-color = "#cdcdcd";
        selection-background = "#252530";
        selection-foreground = "#cdcdcd";
      };
    };
  };
}
