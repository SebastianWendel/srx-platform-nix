{ lib, ... }:
{
  services.xserver.displayManager.gdm = {
    enable = lib.mkDefault true;
    wayland = lib.mkDefault true;
  };
}
