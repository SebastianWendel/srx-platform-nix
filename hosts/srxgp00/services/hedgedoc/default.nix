{ config, ... }:
{
  age.secrets.hedgedocEnvironment = {
    file = ./environment.age;
    owner = "hedgedoc";
  };

  services = {
    hedgedoc = {
      enable = true;
      environmentFile = config.age.secrets.hedgedocEnvironment.path;

      settings = {
        domain = "pad.srx.digital";
        host = "127.0.0.1";
        port = 3005;

        allowAnonymous = true;
        allowAnonymousEdits = true;
        allowEmailRegister = true;
        allowFreeURL = true;
        allowGravatar = false;

        enableStatsAp = true;
        hsts.enable = true;
        protocolUseSSL = true;
        useCDN = false;

        csp = {
          enable = true;
          upgradeInsecureRequest = "auto";
          addDefaults = true;
          allowFraming = false;
          allowPDFEmbed = false;
        };

        db = {
          database = "hedgedoc";
          dialect = "postgres";
          host = "/run/postgresql";
        };

        oauth2 = {
          baseURL = "https://pad.srx.dev";
          userProfileURL = "https://id.srx.digital/realms/srx/protocol/openid-connect/userinfo";
          userProfileUsernameAttr = "preferred_username";
          userProfileDisplayNameAttr = "name";
          userProfileEmailAttr = "email";
          tokenURL = "https://id.srx.digital/realms/srx/protocol/openid-connect/token";
          authorizationURL = "https://id.srx.digital/realms/srx/protocol/openid-connect/auth";
          scope = "openid email profile roles";
          clientID = "pad";
          clientSecret = "$CMD_OAUTH2_CLIENT_SECRET";
        };
      };
    };

    postgresql = {
      ensureDatabases = [ config.services.hedgedoc.settings.db.database ];
      ensureUsers = [{
        name = config.services.hedgedoc.settings.db.database;
        ensureDBOwnership = true;
      }];
    };

    postgresqlBackup.databases = [ config.services.hedgedoc.settings.db.database ];

    nginx.virtualHosts."${toString config.services.hedgedoc.settings.domain}" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass =
        "http://${config.services.hedgedoc.settings.host}:${toString config.services.hedgedoc.settings.port}";
    };

    prometheus.scrapeConfigs = [{
      job_name = "hedgedoc";
      scrape_interval = "60s";
      metrics_path = "/metrics";
      scheme = "http";
      static_configs = [{ targets = [ "${config.services.hedgedoc.settings.host}:${toString config.services.hedgedoc.settings.port}" ]; }];
    }];

    telegraf.extraConfig.inputs = {
      x509_cert = [{
        sources = [ "https://${config.services.hedgedoc.settings.domain}:443" ];
        tags.host = config.services.hedgedoc.settings.domain;
        interval = "10m";
      }];

      http_response = [{
        urls = [ "https://${config.services.hedgedoc.settings.domain}" ];
        tags.host = config.services.hedgedoc.settings.domain;
        interval = "10m";
      }];
    };
  };
}
