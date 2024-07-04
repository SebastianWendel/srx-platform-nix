{ lib, pkgs, ... }:
{
  services = {
    xserver = {
      enable = lib.mkDefault true;
      updateDbusEnvironment = lib.mkDefault true;
      desktopManager.gnome.extraGSettingsOverridePackages = with pkgs; [
        gsettings-desktop-schemas
        gnome.gnome-shell
        gnome.dconf-editor
        gnome.gnome-calculator
        gnome.gnome-calendar
        gnome.simple-scan
      ];
    };

    libinput.enable = lib.mkDefault true;
    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    gnome = {
      at-spi2-core.enable = lib.mkDefault true;
      core-os-services.enable = lib.mkDefault true;
      core-utilities.enable = lib.mkDefault true;
      glib-networking.enable = lib.mkDefault true;
      gnome-browser-connector.enable = lib.mkDefault true;
      gnome-keyring.enable = lib.mkDefault true;
      gnome-online-accounts.enable = lib.mkDefault true;
      gnome-remote-desktop.enable = lib.mkDefault true;
      gnome-settings-daemon.enable = lib.mkDefault true;
      gnome-user-share.enable = lib.mkDefault true;
      rygel.enable = lib.mkDefault true;
      sushi.enable = lib.mkDefault true;

      # disable defaults
      games.enable = lib.mkForce false;
      gnome-online-miners.enable = lib.mkForce false;
      tracker-miners.enable = lib.mkForce false;
    };
  };

  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gnome
  ];

  programs = {
    gnome-disks.enable = true;
    gpaste.enable = true;
    seahorse.enable = true;
    nautilus-open-any-terminal.enable = true;
  };
}
