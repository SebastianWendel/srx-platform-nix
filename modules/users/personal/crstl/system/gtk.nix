{ lib, pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      name = lib.mkForce "palenight";
      package = lib.mkForce pkgs.palenight-theme;
    };
    iconTheme = {
      name = lib.mkForce "Nordzy-purple-dark";
      package = lib.mkForce pkgs.nordzy-icon-theme;
    };
  };
}
