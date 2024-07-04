{ pkgs, self, config, ... }:
{
  imports = [
    self.nixosModules.roles-desktop
  ];

  users.extraUsers.kodi.isNormalUser = true;

  services = {
    xserver.desktopManager.kodi.enable = true;

    displayManager.autoLogin = {
      enable = true;
      user = "kodi";
    };

    cage = {
      enable = true;
      user = "kodi";
      program = "${pkgs.kodi-wayland}/bin/kodi-standalone";
    };
  };

  home-manager.users.kodi = {
    home = {
      username = config.users.users.kodi.name;
      stateVersion = "24.05";
    };
    programs.kodi.enable = true;
  };

  environment.systemPackages = [
    (pkgs.kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [
      inputstream-adaptive
      inputstream-ffmpegdirect
      inputstream-rtmp
      inputstreamhelper
      pvr-hdhomerun
      pvr-hts
      pvr-iptvsimple
      sendtokodi
      websocket

      arteplussept
      mediacccde
      mediathekview
      orftvthek
      radioparadise
      youtube
    ]))
  ];
}
