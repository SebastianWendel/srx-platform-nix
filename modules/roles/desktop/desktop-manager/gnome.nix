{ lib, ... }: {
  imports = [ ./default.nix ];

  services.xserver.desktopManager.gnome.enable = lib.mkDefault true;
}
