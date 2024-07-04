{ config, ... }:
let
  name = "grafana";
  domain = "metrics.srx.digital";
in
{
  age.secrets = {
    grafanaOidcSecret.file = ./oidc-secret.age;
    grafanaOidcSecret.owner = name;
  };

  services = {
    grafana = {
      enable = true;
      settings = {
        analytics.reporting_enabled = false;

        server = {
          inherit domain;
          root_url = "https://${config.services.grafana.settings.server.domain}";
          http_port = 3003;
          enforce_domain = true;
          enable_gzip = true;
        };

        database = {
          type = "postgres";
          url = "postgres:///${name}?host=/run/postgresql&user=${name}";
        };

        smtp = {
          enabled = true;
          host = "mail.srx.digital";
          from_name = "SRX Metrics";
          from_address = "no-reply@srx.digital";
          user = "no-reply@srx.digital";
          key_file = config.age.secrets.forgejoMailerPassword.path;
          startTLS_policy = "MandatoryStartTLS";
        };

        security = {
          cookie_secure = true;
          disable_gravatar = true;
          strict_transport_security = true;
          admin_user = "service";
        };

        "auth.generic_oauth" = {
          enabled = true;
          auto_login = false;
          name = "OpenID";
          icon = "signin";
          allow_sign_up = true;
          client_id = "metrics";
          client_secret = "$__file{${toString config.age.secrets.grafanaOidcSecret.path}}";
          scopes = "openid profile email";
          auth_url = "https://id.srx.digital/realms/srx/protocol/openid-connect/auth";
          token_url = "https://id.srx.digital/realms/srx/protocol/openid-connect/token";
          api_url = "https://id.srx.digital/realms/srx/protocol/openid-connect/userinfo";
        };
      };

      provision.enable = true;
    };

    postgresql = {
      ensureDatabases = [ name ];
      ensureUsers = [{
        inherit name;
        ensureDBOwnership = true;
      }];
    };

    postgresqlBackup.databases = [ name ];

    telegraf.extraConfig.inputs = {
      x509_cert = [{
        sources = [ "https://${config.services.grafana.settings.server.domain}:443" ];
        tags.host = config.services.grafana.settings.server.domain;
        interval = "10m";
      }];

      http_response = [{
        urls = [ "https://${config.services.grafana.settings.server.domain}" ];
        tags.host = config.services.grafana.settings.server.domain;
        interval = "10m";
      }];
    };
  };

  services.nginx.virtualHosts."${domain}" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
    };
  };
}
