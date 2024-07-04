{ lib, pkgs, ... }:
{
  services = {
    system-config-printer.enable = lib.mkDefault true;

    printing = {
      enable = lib.mkDefault true;
      drivers = with pkgs; [
        gutenprint
        gutenprintBin
        hplip
      ];
    };
  };
}
