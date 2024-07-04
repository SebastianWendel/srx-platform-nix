{ self, ... }:
{
  imports = [
    self.nixosModules.services-dns-knot
    self.nixosModules.custom-dns-zones

    ./secrets
    ./acls.nix
    ./policies.nix
    ./remotes.nix
    ./submission.nix
    ./templates.nix
    ./zones.nix
  ];
}
