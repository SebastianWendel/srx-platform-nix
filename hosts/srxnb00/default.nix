{ inputs, lib, ... }:
{
  imports = with inputs; [
    self.nixosModules.roles-workstation
    self.nixosModules.services-storage-syncthing
    ./hardware.nix
    ./storage.nix
    ./services/wireguard.nix
    ./services/restic
  ];

  system.stateVersion = "24.05";

  networking = {
    hostName = "srxnb00";
    domain = "srx.digital";
    hostId = "e7c5e58f";
  };

  nix = {
    gc.options = "--delete-older-than 30d";
    settings.cores = lib.mkForce 12;
  };
}
