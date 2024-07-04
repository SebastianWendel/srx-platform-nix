{ inputs, ... }:
{
  imports = with inputs; [
    self.nixosModules.roles-server
    self.nixosModules.filesystems-zfs
    ./hardware.nix
    ./storage.nix
    ./services/wireguard.nix
    ./services/k3s.nix
  ];

  system.stateVersion = "24.05";

  networking = {
    hostName = "srxk8s00";
    domain = "srx.digital";
    hostId = "8585b085";
  };

  systemd.network.networks."10-uplink" = {
    matchConfig.Name = "enp1s0";
    networkConfig = {
      Address = "2a01:4f8:1c0c:5214::1/64";
      DHCP = "ipv4";
      Gateway = "fe80::1";
      IPv6AcceptRA = "no";
    };
  };
}
