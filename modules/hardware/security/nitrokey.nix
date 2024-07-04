{ lib, pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; lib.optionals config.services.xserver.enable [
    nitrokey-app2
  ];

  hardware.nitrokey.enable = lib.mkDefault true;

  services = {
    pcscd.enable = lib.mkDefault true;
    udev.packages = with pkgs; [
      libu2f-host
    ];
  };
}
