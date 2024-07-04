{ lib, self, ... }:
{
  imports = [
    self.nixosModules.hardware
    self.nixosModules.roles-media-center
    ./hardware.nix
    ./storage.nix
    ./networking/wireguard.nix
    ./networking/wireless.nix
    ./services/mounts
  ];

  system.stateVersion = "24.05";

  networking = {
    hostName = "srxmc00";
    domain = "srx.digital";
    networkmanager.enable = lib.mkForce false;
  };

  systemd.network = {
    enable = true;
    networks."10-wan" = {
      matchConfig.Name = "enp1s0";
      networkConfig.DHCP = "ipv4";
    };
    networks."11-wifi" = {
      matchConfig.Name = "wlp0s12f0";
      networkConfig.DHCP = "ipv4";
    };
  };
}
