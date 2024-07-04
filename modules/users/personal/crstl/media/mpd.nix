{ pkgs, ... }:
{
  xdg.userDirs.enable = true;

  services.mpd.enable = true;

  home.packages = with pkgs; [
    cantata
    mmtc
    rofi-mpd
  ];

  programs.ncmpcpp.enable = true;
}
