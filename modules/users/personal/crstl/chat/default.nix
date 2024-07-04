{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jitsi-meet-electron
    signal-desktop
    element-desktop
    telegram-desktop
    nheko
    slack
  ];
}
