{ lib, pkgs, config, ... }:
{
  imports = [
    ./documentation.nix
    ./fonts.nix
    ./stylix.nix
  ];

  console.useXkbConfig = lib.mkDefault true;

  boot = {
    consoleLogLevel = lib.mkDefault 0;
    plymouth.enable = lib.mkDefault true;
    kernelParams = lib.optionals config.boot.plymouth.enable [ "quiet" ];
  };

  services = {
    dbus = {
      enable = lib.mkDefault true;
      packages = with pkgs; [ gcr ];
    };

    upower.enable = lib.mkDefault true;
    libinput.enable = lib.mkDefault true;
    automatic-timezoned.enable = lib.mkDefault true;
    gvfs.enable = lib.mkDefault true;
    flatpak.enable = lib.mkDefault true;

    # disable default services
    geoclue2.enable = lib.mkForce false;
  };

  location = {
    latitude = 53.0;
    longitude = 10.0;
  };

  xdg = {
    autostart.enable = lib.mkDefault true;
    sounds.enable = lib.mkDefault true;
    icons.enable = lib.mkDefault true;
    menus.enable = lib.mkDefault true;
    mime.enable = lib.mkDefault true;

    portal = {
      enable = lib.mkDefault true;
      wlr.enable = lib.mkDefault true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
      ];
    };
  };

  programs = {
    nm-applet.enable = true;
    light.enable = true;
  };

  networking = {
    networkmanager.enable = lib.mkDefault true;

    # fix NetworkManager's Wireguard integration
    firewall.checkReversePath = lib.mkDefault false;
  };

  environment.systemPackages = with pkgs; [
    wdisplays
    pavucontrol
    libcamera
  ];
}
