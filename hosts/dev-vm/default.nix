{ self, ... }:
{
  imports = [
    self.nixosModules.roles-workstation
    ./hardware.nix
    ./storage.nix
  ];

  system.stateVersion = "24.05";

  networking = {
    hostName = "dev-vm";
    hostId = "ea0023ed";
  };

  systemd.network = {
    enable = true;
    networks."10-uplink" = {
      matchConfig.Name = "enp1s0";
      address = [ "192.168.122.26/24" ];
      routes = [
        { routeConfig.Gateway = "192.168.122.1"; }
        { routeConfig.Gateway = "fe80::1"; }
      ];
    };
  };
}
