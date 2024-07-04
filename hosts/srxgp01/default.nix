{ inputs, lib, ... }:
{
  imports = with inputs; [
    self.nixosModules.roles-server
    self.nixosModules.filesystems-zfs
    self.nixosModules.services-security-tang
    self.nixosModules.custom-dns-knot
    ./hardware.nix
    ./storage.nix
    ./services/wireguard.nix
  ];

  system.stateVersion = "24.05";

  networking = {
    hostName = "srxgp01";
    domain = "srx.digital";
    hostId = "8666b002";
  };

  systemd.network.networks."10-uplink" = {
    matchConfig.Name = "enp3s0";
    networkConfig = {
      Address = "2a0a:4cc0:1:131a::1/64";
      DHCP = "ipv4";
      Gateway = "fe80::1";
      IPv6AcceptRA = "no";
    };
  };

  services.knot.settings.server = {
    identity = "ns2.srx.dev";
    listen = lib.mkForce [
      "10.80.0.5@53"
      "152.53.17.250@53"
      "2a0a:4cc0:1:131a::1@53"
    ];
  };
}
