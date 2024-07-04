{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    simple-scan
  ];

  hardware.sane = {
    enable = lib.mkDefault true;
    drivers = {
      scanSnap.enable = lib.mkDefault true;
    };
  };
}
