{ pkgs, ... }:
{
  home.packages = with pkgs;    [
    orca-slicer
    super-slicer-latest
  ];
}
