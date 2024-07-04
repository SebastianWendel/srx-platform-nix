{ self, ... }:
{
  imports = [
    self.nixosModules.roles-core
    ./hardware.nix
    ./services/wireguard.nix
    # ./services/moonraker.nix
    # ./services/fluidd.nix
    # ./services/klipper
    # ./services/octoprint.nix
  ];

  networking.hostName = "srxfdm00";

  system.stateVersion = "24.05";
}
