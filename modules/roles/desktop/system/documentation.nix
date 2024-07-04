{ lib, ... }:
{
  documentation = {
    enable = lib.mkForce true;
    nixos.enable = lib.mkForce true;
    doc.enable = lib.mkForce true;
    man.enable = lib.mkForce true;
    info.enable = lib.mkForce true;
  };
}
