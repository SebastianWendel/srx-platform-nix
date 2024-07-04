{ self, inputs, config, ... }:
{
  flake.hydraJobs = {
    inherit (self) checks packages;
  };

  perSystem = { pkgs, self', system, ... }:
    let
      inherit (config) flake;
      inherit (pkgs) lib linkFarm;
      nixosDrvs = lib.mapAttrs (_: nixos: nixos.config.system.build.toplevel) flake.nixosConfigurations;
      homeDrvs = lib.mapAttrs (_: home: home.activationPackage) flake.homeConfigurations;
      hostDrvs = nixosDrvs // homeDrvs;
      compatHosts = lib.filterAttrs (_: host: host.hostPlatform == system) flake.hosts;
      compatHostDrvs = lib.mapAttrs (name: _: hostDrvs.${name}) compatHosts;
      compatHostsFarm = linkFarm "hosts-${system}" (lib.mapAttrsToList (name: path: { inherit name path; }) compatHostDrvs);
      packagesAdditional = { inherit (pkgs) nix-fast-build; };
      packagesBlacklist = [ ];
      packages = lib.mapAttrs' (name: lib.nameValuePair "package-${name}") (
        lib.filterAttrs (name: _v: !(builtins.elem name packagesBlacklist)) self'.packages);
    in
    {
      _module.args = {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
          config = {
            allowUnfree = true;
            allowAliases = true;
          };
        };
      };

      packages = (
        lib.optionalAttrs (compatHosts != { }) { default = compatHostsFarm; }
      ) // compatHostDrvs // packagesAdditional;

      checks = packages;
    };
}
