{ inputs, ... }:
let
  inherit (inputs) self deploy-rs nixpkgs;
  inherit (nixpkgs) lib;

  genNode =
    hostName: nixosCfg:
    let
      inherit (self.hosts.${hostName}) address hostPlatform remoteBuild;
      inherit (deploy-rs.lib.${hostPlatform}) activate;
    in
    {
      inherit remoteBuild;
      hostname = address;
      profiles.system.path = activate.nixos nixosCfg;
    };
in
{
  flake.deploy = {
    # autoRollback = true;
    # magicRollback = true;
    autoRollback = false;
    magicRollback = false;
    user = "root";
    nodes = lib.mapAttrs genNode (self.nixosConfigurations or { });
  };
}
