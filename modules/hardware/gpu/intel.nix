{ lib, pkgs, ... }:
{
  hardware = {
    opengl = {
      enable = lib.mkDefault true;
      driSupport = lib.mkDefault true;
    };
  };

  environment.systemPackages = with pkgs; [ intel-gpu-tools ];
}
