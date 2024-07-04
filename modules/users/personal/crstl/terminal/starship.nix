{ lib, ... }:
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;
      scan_timeout = 10;

      status = {
        map_symbol = true;
        pipestatus = true;
      };

      format = lib.concatStrings [
        "$all"
        "$line_break"
        "$character"
      ];

      character = {
        success_symbol = " [λ](bold green)";
        error_symbol = " [λ](bold red)";
      };

      nix_shell.symbol = "❄️ ";
      aws.disabled = true;

      directory = {
        style = "cyan";
        read_only = " 🔒";
      };

      battery = {
        charging_symbol = "⚡️";
        display = [
          {
            threshold = 10;
            style = "bold red";
          }
        ];
      };

      cmd_duration.show_notifications = true;

      git_metrics = {
        format = "[+$added]($added_style)/[-$deleted]($deleted_style)";
      };

      git_status = {
        ahead = ''⇡''${count}'';
        diverged = ''⇕⇡''${ahead_count}⇣''${behind_count}'';
        behind = ''⇣''${count}'';
      };

      shlvl = {
        symbol = "↕ ";
      };
    };
  };
}
