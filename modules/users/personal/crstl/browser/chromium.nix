{ pkgs, ... }:
{
  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    commandLineArgs = [
      # https://github.com/ungoogled-software/ungoogled-chromium/blob/master/docs/flags.md
      "--enable-logging=stderr"
      "--no-service-autorun"
      "--password-store=gnome"
    ];
    dictionaries = with pkgs.hunspellDictsChromium; [
      en_US
      de_DE
    ];
  };
}
