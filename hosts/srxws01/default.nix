{ inputs, ... }:
{
  imports = with inputs; [
    self.nixosModules.roles-workstation
    self.nixosModules.filesystems-zfs
    self.nixosModules.services-storage-syncthing
    ./hardware.nix
    ./storage.nix
    ./services/wireguard.nix
  ];

  system.stateVersion = "24.05";

  networking = {
    hostName = "srxws01";
    domain = "srx.digital";
    hostId = "591d44f4";

    interfaces = {
      eno1.wakeOnLan.enable = true;
      eno2.wakeOnLan.enable = true;
    };
  };

  systemd.network = {
    enable = true;
    networks."10-uplink" = {
      matchConfig.Name = "eno1";
      address = [ "10.50.0.11/23" ];
      routes = [
        { routeConfig.Gateway = "10.50.0.1"; }
        { routeConfig.Gateway = "fe80::1"; }
      ];
    };
  };
}
