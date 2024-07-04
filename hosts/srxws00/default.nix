{ inputs, ... }:
{
  imports = with inputs; [
    self.nixosModules.roles-workstation
    self.nixosModules.filesystems-zfs
    self.nixosModules.services-storage-syncthing
    ./hardware.nix
    ./storage.nix
    ./services/wireguard.nix
    ./services/nfs.nix
  ];

  system.stateVersion = "24.05";

  networking = {
    hostName = "srxws00";
    domain = "srx.digital";
    hostId = "9222a8ae";

    interfaces = {
      eno1.wakeOnLan.enable = true;
      eno2.wakeOnLan.enable = true;
    };
  };
}
