{ inputs, ... }:
{
  imports = with inputs; [
    self.nixosModules.roles-workstation
    self.nixosModules.services-storage-syncthing
    ./hardware.nix
    ./services/wireguard.nix
  ];

  system.stateVersion = "23.11";

  networking = {
    hostName = "srxtab00";
    domain = "srx.digital";
    hostId = "81774791";
  };
}
