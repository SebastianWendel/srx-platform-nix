{ config, ... }:
let
  host = "vault.srx.digital";
  owner = "vaultwarden";
in
{
  age.secrets.vaultwarden = {
    file = ./secrets.age;
    inherit owner;
    group = owner;
  };

  environment.etc = {
    "fail2ban/filter.d/vaultwarden.conf".text = ''
      [INCLUDES]
      before = common.conf

      [Definition]
      failregex = ^.*Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$
      ignoreregex =
      journalmatch = _SYSTEMD_UNIT=vaultwarden.service
    '';

    "fail2ban/filter.d/vaultwarden-admin.conf".text = ''
      [INCLUDES]
      before = common.conf

      [Definition]
      failregex = ^.*Invalid admin token\. IP: <ADDR>.*$
      ignoreregex =
      journalmatch = _SYSTEMD_UNIT=vaultwarden.service
    '';
  };

  services = {
    vaultwarden = {
      enable = true;

      environmentFile = config.age.secrets.vaultwarden.path;
      dbBackend = "postgresql";

      config = {
        DOMAIN = "https://${host}";
        SIGNUPS_ALLOWED = false;

        DATABASE_URL = "postgresql://@/${owner}";

        SMTP_HOST = "mail.srx.digital";
        SMTP_FROM = "no-reply@srx.digital";
        SMTP_USERNAME = "no-reply@srx.digital";
        SMTP_PORT = 465;
        SMTP_SSL = true;
        SMTP_SECURITY = "force_tls";

        ROCKET_ADDRESS = "::1";
        ROCKET_PORT = 8812;

        ENABLE_WEBSOCKET = true;
      };
    };

    postgresql = {
      enable = true;
      ensureDatabases = [ owner ];

      ensureUsers = [
        {
          name = owner;
          ensureDBOwnership = true;
        }
      ];
    };

    postgresqlBackup.databases = [ owner ];

    nginx.virtualHosts."${host}" = {
      enableACME = true;
      forceSSL = true;

      locations."/".proxyPass = "http://[::1]:${toString config.services.vaultwarden.config.ROCKET_PORT}/";

      locations."/notifications/hub" = {
        proxyPass = "http://[::1]:${toString config.services.vaultwarden.config.ROCKET_PORT}/";
        proxyWebsockets = true;
      };
    };

    fail2ban.jails = {
      vaultwarden = ''
        enabled = true
        filter = vaultwarden
        port = 80,443,8000
        maxretry = 5
      '';

      vaultwarden-admin = ''
        enabled = true
        port = 80,443
        filter = vaultwarden-admin
        maxretry = 3
        bantime = 14400
        findtime = 14400
      '';
    };

    telegraf.extraConfig.inputs = {
      x509_cert = [{
        sources = [ "https://${host}:443" ];
        tags.host = host;
        interval = "10m";
      }];

      http_response = [{
        urls = [ "https://${host}" ];
        tags.host = host;
        interval = "10m";
      }];
    };
  };
}
