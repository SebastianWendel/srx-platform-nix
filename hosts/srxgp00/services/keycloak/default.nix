{ config, ... }:
{
  age.secrets.keycloakDatabasePassword.file = ./databasePassword.age;

  services = {
    keycloak = {
      enable = true;
      database.passwordFile = config.age.secrets.keycloakDatabasePassword.path;
      settings = {
        hostname = "id.srx.digital";
        proxy = "edge";
        http-host = "127.0.0.1";
        http-port = 8787;
        hostname-strict-backchannel = true;
        metrics-enabled = true;
      };
    };

    postgresqlBackup.databases = [ config.services.keycloak.database.name ];

    nginx.virtualHosts."${config.services.keycloak.settings.hostname}" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://${config.services.keycloak.settings.http-host}:${toString config.services.keycloak.settings.http-port}";
    };

    prometheus.scrapeConfigs = [{
      job_name = "keycloak";
      static_configs = [{
        targets = [ "${config.services.keycloak.settings.http-host}:${toString config.services.keycloak.settings.http-port}" ];
      }];
    }];

    telegraf.extraConfig.inputs = {
      x509_cert = [{
        sources = [ "https://${config.services.keycloak.settings.hostname}:443" ];
        tags.host = config.services.keycloak.settings.hostname;
        interval = "10m";
      }];

      http_response = [{
        urls = [ "https://${config.services.keycloak.settings.hostname}" ];
        tags.host = config.services.keycloak.settings.hostname;
        interval = "10m";
      }];
    };
  };
}
