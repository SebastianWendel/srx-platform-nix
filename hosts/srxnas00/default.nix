{ self, ... }:
{
  imports = [
    self.nixosModules.hardware
    self.nixosModules.roles-nas
    self.nixosModules.roles-desktop
    self.nixosModules.services-security-tang
    ./hardware.nix
    ./storage.nix
    ./network/wireguard
    ./network/knsupdate
    ./storage/nfs
    ./services/apcupsd
    ./services/mosquitto
    ./services/home-assistant
    ./services/zigbee2mqtt
    ./services/rtl-sdr
    ./services/minidlna
    ./services/jellyfin
    ./services/vdr
    ./services/netboot
    ./services/vault
  ];

  system.stateVersion = "24.05";

  networking = {
    hostName = "srxnas00";
    domain = "srx.digital";
    hostId = "4e34e4ef";
  };

  systemd.network = {
    enable = true;
    networks."10-uplink" = {
      matchConfig.Name = "enp1s0";
      networkConfig.DHCP = "ipv4";
    };
  };

  systemd.oomd.enable = false;
}
