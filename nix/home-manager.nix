{ withSystem, inputs, ... }:
let
  inherit (inputs) self home-manager nixpkgs;
  inherit (nixpkgs) lib;

  genModules = hostName: { homeDirectory, ... }: { config, ... }: {
    imports = [ (../hosts + "/${hostName}") ];
    nix.registry = {
      nixpkgs.flake = nixpkgs;
      p.flake = nixpkgs;
    };

    home = {
      inherit homeDirectory;
      sessionVariables.NIX_PATH = lib.concatStringsSep ":" [ "nixpkgs=${config.xdg.dataHome}/nixpkgs" ];
    };

    xdg = {
      dataFile.nixpkgs.source = nixpkgs;
      configFile."nix/nix.conf".text = ''
        flake-registry = ${config.xdg.configHome}/nix/registry.json
      '';
    };
  };

  genConfiguration = hostName: { hostPlatform, type, ... }@attrs:
    withSystem hostPlatform (
      { pkgs, ... }:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ (genModules hostName attrs) ];
        extraSpecialArgs = {
          hostType = type;
          inherit inputs self;
        };
      }
    );
in
{
  flake.homeConfigurations = lib.mapAttrs genConfiguration (
    lib.filterAttrs (_: host: host.type == "home-manager") self.hosts
  );

  perSystem = { lib, self', ... }: {
    checks = lib.mapAttrs'
      (name: config: lib.nameValuePair "home-manager-${name}" config.activation-script)
      (self'.legacyPackages.homeConfigurations or { });
  };
}
