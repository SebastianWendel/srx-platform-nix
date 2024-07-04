{ lib, config, ... }:
{
  hardware.bluetooth.enable = lib.mkDefault true;

  services.blueman.enable = lib.mkIf config.services.xserver.enable true;
}
