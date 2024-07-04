{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kicad
    # kikit
    # kicadAddons.kikit
    # kicadAddons.kikit-library
  ];
}
