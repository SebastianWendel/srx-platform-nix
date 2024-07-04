{ pkgs, ... }:
{
  home.packages = with pkgs; [
    openscad
    openscad-lsp
    sca2d
  ];

  programs.vscode.extensions = with pkgs.vscode-extensions; [
    antyos.openscad
  ];
}
