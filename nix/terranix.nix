{ self, lib, nixpkgs, inputs, ... }:
{
  flake.lib.terraform = import ../lib/terraform.nix { inherit self inputs lib nixpkgs; };

  perSystem = { pkgs, system, inputs', self', ... }:
    let
      tofuLib = self.lib.terraform { inherit (self'.packages) opentofu; inherit pkgs tufoConfigAst; };
      tufoConfigAst = inputs.terranix.lib.terranixConfigurationAst {
        inherit system pkgs;
        modules = [ ../terranix ];
      };
    in
    {
      devShells.opentofu = pkgs.mkShell {
        packages = [
          self'.packages.json2nix
          self'.packages.opentofu
          (inputs'.terranix.packages.terranix.override { nix = pkgs.nixVersions.latest; })
        ];
      };

      apps = tofuLib.mkApps [
        "init"
        "plan"
        "apply"
        "destroy"
        "state"
        "import"
      ] // { inherit (tofuLib) tf-validate tf2nix; };

      packages = {
        inherit (tofuLib) tf-state;

        opentofu = pkgs.opentofu.withPlugins (tp: [
          tp.github
          tp.grafana
          tp.hcloud
          tp.helm
          tp.hydra
          tp.keycloak
          tp.minio

          (pkgs.opentofu.plugins.mkProvider {
            owner = "go-gitea";
            repo = "terraform-provider-gitea";
            rev = "v0.3.0";
            vendorHash = "sha256-+jTenvGCfqI8I3//kc/kCa7kTIyzSGKjJXP6otKJBRA=";
            spdx = "MIT";
            hash = "sha256-qUVF3JS3sOisAhgBHvpDsb6rEFXyQTU9Bga1WjetYL0=";
            homepage = "https://registry.terraform.io/providers/go-gitea/gitea";
            provider-source-address = "registry.terraform.io/go-gitea/gitea";
          })
        ]);

        json2nix = pkgs.writeScriptBin "json2nix" ''
          ${pkgs.python3}/bin/python ${pkgs.fetchurl {
            url = "https://gist.githubusercontent.com/Scoder12/0538252ed4b82d65e59115075369d34d/raw/e86d1d64d1373a497118beb1259dab149cea951d/json2nix.py";
            hash = "sha256-ROUIrOrY9Mp1F3m+bVaT+m8ASh2Bgz8VrPyyrQf9UNQ=";
          }} $@
        '';
      };
    };
}
