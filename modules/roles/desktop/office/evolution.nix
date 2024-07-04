{ lib, pkgs, ... }:
{
  programs.evolution = {
    enable = lib.mkDefault true;
    plugins = with pkgs; [
      evolution-ews
    ];
  };

  services.gnome.evolution-data-server.enable = lib.mkDefault true;
}
