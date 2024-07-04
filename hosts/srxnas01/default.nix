{ self, ... }:
{
  imports = [
    self.nixosModules.roles-nas
    self.nixosModules.services-security-tang
    self.nixosModules.services-virtualisation-microvm
    ./hardware.nix
    ./storage.nix
    ./network/wireguard
    ./network/knsupdate
    ./services/minidlna
  ];

  system.stateVersion = "24.05";

  networking = {
    hostName = "srxnas01";
    domain = "srx.digital";
    hostId = "8656cb50";
  };

  systemd.network = {
    enable = true;
    networks."10-uplink" = {
      matchConfig.Name = "enp2s0";
      address = [ "10.50.0.10/23" ];
      routes = [
        { routeConfig.Gateway = "10.50.0.1"; }
        { routeConfig.Gateway = "fe80::1"; }
      ];
    };
  };

  fileSystems."/mnt/cryptix" = {
    device = "aufdie12.lan:/mnt/main/sort";
    fsType = "nfs";
    options = [
      "noauto"
      "X-mount.mkdir"
      "x-systemd.automount"
      "x-systemd.device-timeout=5s"
      "x-systemd.idle-timeout=60"
      "x-systemd.mount-timeout=5s"
    ];
  };
}
