{ lib, pkgs, inputs, ... }:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  environment.systemPackages = with pkgs; [ sbctl ];

  boot = {
    bootspec = {
      enable = lib.mkDefault true;
      enableValidation = lib.mkDefault true;
    };
    lanzaboote = {
      enable = lib.mkDefault true;
      pkiBundle = "/etc/secureboot";
    };
    loader = {
      systemd-boot.enable = lib.mkForce false;
      grub.enable = lib.mkForce false;
    };
  };
}
