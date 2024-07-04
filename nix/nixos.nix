{ self, inputs, withSystem, ... }:
let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs) lib;

  genConfiguration = hostname: { address, hostPlatform, type, ... }:
    withSystem hostPlatform (
      { pkgs, ... }:
      lib.nixosSystem {
        modules = [
          (../hosts + "/${hostname}")
          {
            nixpkgs.pkgs = pkgs;
            nix.registry = {
              p.flake = nixpkgs;
              nixpkgs.flake = nixpkgs;
            };
            nixpkgs.hostPlatform = hostPlatform;
          }
        ];

        specialArgs = {
          hostType = type;
          hostAddress = address;
          inherit self inputs;
        };
      }
    );
in
{
  flake.nixosConfigurations = lib.mapAttrs genConfiguration (
    lib.filterAttrs (_: host: host.type == "nixos") inputs.self.hosts
  );

  perSystem = { lib, pkgs, system, ... }: {
    checks = lib.mapAttrs'
      (name: config: lib.nameValuePair "nixos-${name}" config.config.system.build.toplevel)
      ((lib.filterAttrs (_: config: config.pkgs.system == system)) self.nixosConfigurations);
  };
}
