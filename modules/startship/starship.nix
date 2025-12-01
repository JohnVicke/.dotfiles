{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch$git_state"
        "$fill"
        "$line_break"
        "$character"
      ];
      fill = {
        symbol = " ";
      };
      git_state = {
        format = "\\([$state( $progress_current/$progress_total)]($style)\\)";
        style = "bright-black";
      };
      gcloud = {
        format = "\\[[$symbol$project]($style)\\]";
        symbol = "";
      };
    };
  };
}
