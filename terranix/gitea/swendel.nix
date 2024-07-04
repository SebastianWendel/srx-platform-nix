{ lib, ... }:
{
  resource = {
    gitea_repository = {
      gitea-repo-gitHub-profile = {
        username = "swendel";
        name = "SebastianWendel";
        description = "My personal GitHub profile.";
        website = "https://srx.digital";
        migration_clone_address = "https://github.com/SebastianWendel/SebastianWendel.git";
        migration_service_auth_token = lib.tfRef "var.GITHUB_TOKEN";
        migration_service = "github";
        mirror = true;
        has_issues = true;
        has_wiki = false;
        private = false;
      };

      gitea-mirror-nixpkgs = {
        username = "swendel";
        name = "nixpkgs";
        description = "Mirror of nixpkgs";
        website = "https://github.com/SebastianWendel/nixpkgs.git";
        migration_clone_address = "https://github.com/SebastianWendel/nixpkgs.git";
        mirror = true;
        has_issues = true;
        has_wiki = true;
        private = false;
      };

      gitea-mirror-bionet = {
        username = "swendel";
        name = "bionet";
        description = "Image classification";
        website = "https://code.curious.bio/swendel/bionet.git";
        migration_clone_address = "https://code.curious.bio/swendel/bionet.git";
        migration_service = "gitea";
        migration_service_auth_token = lib.tfRef "var.GITEA_MIRROR_TOKEN_CCL";
        private = true;
      };

      gitea-mirror-birdnet-nix = {
        username = "swendel";
        name = "birdnet-nix";
        description = "Nixified BirdNet";
        website = "https://code.curious.bio/swendel/birdnet-nix.git";
        migration_clone_address = "https://code.curious.bio/swendel/birdnet-nix.git";
        migration_service = "gitea";
        migration_service_auth_token = lib.tfRef "var.GITEA_MIRROR_TOKEN_CCL";
        private = true;
      };

      gitea-mirror-esphome-components = {
        username = "swendel";
        name = "esphome-components";
        website = "https://code.curious.bio/swendel/esphome-components.git";
        migration_clone_address = "https://code.curious.bio/swendel/esphome-components.git";
        migration_service = "gitea";
        migration_service_auth_token = lib.tfRef "var.GITEA_MIRROR_TOKEN_CCL";
        private = true;
      };
    };
  };
}
