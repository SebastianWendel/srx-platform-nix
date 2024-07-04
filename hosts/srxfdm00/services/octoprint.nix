{ pkgs, ... }:
{
  services.octoprint = {
    enable = true;
    openFirewall = true;
    plugins = with pkgs.octoprint.plugins; [
      themeify
      stlviewer
    ];
  };
}
