{ self, ... }:
{
  imports = [
    self.nixosModules.services-web-nginx
    ./checkip.nix
    ./nix-hamburg.nix
    ./srx.digital.nix
    ./srx81.de.nix
  ];
}
