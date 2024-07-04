{ inputs, pkgs, ... }:
{
  imports = with inputs; [
    nixos-hardware.nixosModules.common-gpu-amd
  ];

  environment.systemPackages = with pkgs; [
    clinfo
    radeontop
    radeontools
  ];
}
