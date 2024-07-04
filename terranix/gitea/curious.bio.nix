{ lib, ... }:
{
  variable.GITEA_MIRROR_TOKEN_CCL = {
    type = "string";
    sensitive = true;
  };

  resource = {
    gitea_org.gitea-org-curious-bio = {
      name = "ccl";
      full_name = "Curious Community Labs e. V.";
      location = "Hamburg, Germany";
      website = "https://curious.bio/";
      visibility = "public";
    };

    gitea_repository = {
      gitea-mirror-iot-backend = {
        username = lib.tfRef "gitea_org.gitea-org-curious-bio.name";
        name = "iot-backend";
        description = "An Open-Source prototype for collecting, working with and displaying sensor data from MQTT enabled IoT devices. https://wiki.curious.bio/de/Projekte/IoT-Plattform";
        website = "https://code.curious.bio/curious.bio/iot-backend.git";
        migration_clone_address = "https://code.curious.bio/curious.bio/iot-backend.git";
        mirror = true;
        has_issues = false;
        has_wiki = false;
        private = false;
        depends_on = [ "gitea_org.gitea-org-curious-bio" ];
      };

      gitea-mirror-infra-nix = {
        username = lib.tfRef "gitea_org.gitea-org-curious-bio.name";
        name = "infra.nix";
        description = "CCL NixOS config";
        website = "https://code.curious.bio/curious.bio/infra.nix";
        migration_clone_address = "https://code.curious.bio/curious.bio/infra.nix";
        migration_service = "gitea";
        migration_service_auth_token = lib.tfRef "var.GITEA_MIRROR_TOKEN_CCL";
        mirror = true;
        has_issues = false;
        has_wiki = false;
        private = true;
        depends_on = [ "gitea_org.gitea-org-curious-bio" ];
      };

      gitea-mirror-smart-energy-monitor = {
        username = lib.tfRef "gitea_org.gitea-org-curious-bio.name";
        name = "smart-energy-monitor";
        description = "A smart energy monitor to measure the power consumption https://wiki.curious.bio/de/Projekte/IoT-Plattform";
        website = "https://code.curious.bio/curious.bio/smart-energy-monitor.git";
        migration_clone_address = "https://code.curious.bio/curious.bio/smart-energy-monitor.git";
        mirror = true;
        has_issues = false;
        has_wiki = false;
        private = false;
        depends_on = [ "gitea_org.gitea-org-curious-bio" ];
      };


      gitea-mirror-mushlab-iot = {
        username = lib.tfRef "gitea_org.gitea-org-curious-bio.name";
        name = "mushlab-iot";
        website = "https://code.curious.bio/curious.bio/mushlab-iot.git";
        migration_clone_address = "https://code.curious.bio/curious.bio/mushlab-iot.git";
        mirror = true;
        has_issues = false;
        has_wiki = false;
        private = false;
        depends_on = [ "gitea_org.gitea-org-curious-bio" ];
      };

      gitea-mirror-vermiloop = {
        username = lib.tfRef "gitea_org.gitea-org-curious-bio.name";
        name = "vermiloop";
        website = "https://code.curious.bio/curious.bio/vermiloop.git";
        migration_clone_address = "https://code.curious.bio/curious.bio/vermiloop.git";
        mirror = true;
        has_issues = false;
        has_wiki = false;
        private = false;
        depends_on = [ "gitea_org.gitea-org-curious-bio" ];
      };

      gitea-mirror-planktoscope = {
        username = lib.tfRef "gitea_org.gitea-org-curious-bio.name";
        name = "planktoscope";
        website = "https://code.curious.bio/curious.bio/planktoscope.git";
        migration_clone_address = "https://code.curious.bio/curious.bio/planktoscope.git";
        mirror = true;
        has_issues = false;
        has_wiki = false;
        private = false;
        depends_on = [ "gitea_org.gitea-org-curious-bio" ];
      };

      gitea-mirror-nix-cyanovision = {
        username = lib.tfRef "gitea_org.gitea-org-curious-bio.name";
        name = "nix-cyanovision";
        website = "https://code.curious.bio/curious.bio/nix-cyanovision.git";
        migration_clone_address = "https://code.curious.bio/curious.bio/nix-cyanovision.git";
        mirror = true;
        has_issues = false;
        has_wiki = false;
        private = false;
        depends_on = [ "gitea_org.gitea-org-curious-bio" ];
      };
    };
  };
}
