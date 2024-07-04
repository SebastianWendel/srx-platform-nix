{ pkgs, ... }:
{
  home.packages = with pkgs;    [
    appimage-run
    filezilla
    gimp
    inkscape
    libreoffice-fresh
    meld
    remmina
    strawberry
    transmission_4-gtk
    transmission-rss
    transmission-remote-gtk
  ];
}
