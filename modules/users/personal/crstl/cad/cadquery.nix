{ pkgs, ... }:
{
  home.packages = with pkgs; [ cq-editor ];
}
