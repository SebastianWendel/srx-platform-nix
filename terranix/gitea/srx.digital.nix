{ lib, ... }:
{
  resource = {
    gitea_org.gitea-org-srx-digital = {
      name = "srx";
      full_name = "srx development & operations";
      location = "Hamburg, Germany";
      website = "https://srx.digital";
      visibility = "public";
    };

    gitea_repository = {
      gitea-repo-srx-nixos-shadow = {
        username = lib.tfRef "gitea_org.gitea-org-srx-digital.name";
        name = "srx-nixos-shadow";
        description = "The hidden part of the srx.digital NixOS platform";
        auto_init = false;
        private = true;
      };

      srx-platform-nix = {
        username = lib.tfRef "gitea_org.gitea-org-srx-digital.name";
        name = "srx-platform-nix";
        description = "Nix platform repository";
        migration_clone_address = "https://github.com/SebastianWendel/srx-platform-nix";
        migration_service_auth_token = lib.tfRef "var.GITHUB_TOKEN";
        migration_service = "github";
        has_issues = true;
        has_wiki = true;
        private = false;
        mirror = true;
        website = "https://srx.digital";
        depends_on = [ "gitea_org.gitea-org-srx-digital" ];
      };

      gitea-mirror-fcos-drupal-cms-dev-kit = {
        username = lib.tfRef "gitea_org.gitea-org-srx-digital.name";
        name = "fcos-drupal-cms-dev-kit";
        description = " FCOS Drupal CMS Development Kit";
        website = "https://gitlab.fabcity.hamburg/software/fcos-drupal-cms-dev-kit.git";
        has_issues = false;
        has_wiki = false;
        private = false;
        mirror = true;
        depends_on = [ "gitea_org.gitea-org-srx-digital" ];
      };

      gitea-mirror-fab-city-os-core-chart = {
        username = lib.tfRef "gitea_org.gitea-org-srx-digital.name";
        name = "fab-city-os-core-chart";
        description = "Fab City OS Core Helm Chart for Kubernetes";
        website = "https://gitlab.fabcity.hamburg/software/fab-city-os-core-chart.git";
        migration_clone_address = "https://gitlab.fabcity.hamburg/software/fab-city-os-core-chart.git";
        mirror = true;
        has_issues = false;
        has_wiki = false;
        private = false;
        depends_on = [ "gitea_org.gitea-org-srx-digital" ];
      };

      gitea-mirror-fab-city-software-kit = {
        username = lib.tfRef "gitea_org.gitea-org-srx-digital.name";
        name = "fab-city-software-kit";
        description = "Fab City Software Kit for Kubernetes";
        website = "https://gitlab.fabcity.hamburg/software/fab-city-software-kit.git";
        migration_clone_address = "https://gitlab.fabcity.hamburg/software/fab-city-software-kit.git";
        mirror = true;
        has_issues = false;
        has_wiki = false;
        private = false;
        depends_on = [ "gitea_org.gitea-org-srx-digital" ];
      };
    };
  };
}
