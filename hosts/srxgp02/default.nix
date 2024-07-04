{ inputs, lib, ... }:
{
  imports = with inputs; [
    self.nixosModules.roles-server
    self.nixosModules.services-security-tang
    self.nixosModules.custom-dns-knot
    ./hardware.nix
    ./storage.nix
    ./services/wireguard.nix
  ];

  system.stateVersion = "24.05";

  networking = {
    hostName = "srxgp02";
    domain = "srx.digital";
  };

  systemd.network.networks."10-uplink" = {
    matchConfig.Name = "ens6";
    networkConfig = {
      Address = "2a02:247a:275:9300::1/128";
      DHCP = "ipv4";
      Gateway = "fe80::1";
      IPv6AcceptRA = "no";
    };
  };

  services.knot.settings.server = {
    identity = "ns3.srx.dev";
    listen = lib.mkForce [
      "10.80.0.6@53"
      "212.132.77.48@53"
      "2a02:247a:275:9300::1@53"
    ];
  };
}
