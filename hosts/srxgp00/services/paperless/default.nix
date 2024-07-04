{ config, ... }:
let
  name = "paperless";
  host = "paper.srx.digital";
in
{
  age.secrets.paperlessPassword = {
    file = ./password.age;
    owner = "paperless";
  };

  services = {
    paperless = {
      enable = true;
      passwordFile = config.age.secrets.paperlessPassword.path;
      settings = {
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
        PAPERLESS_ADMIN_USER = "service";
        PAPERLESS_DBHOST = "/run/postgresql";
      };
    };

    postgresql = {
      ensureDatabases = [ name ];
      ensureUsers = [{
        inherit name;
        ensureDBOwnership = true;
      }];
    };

    postgresqlBackup.databases = [ name ];

    nginx.virtualHosts."${host}" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://${config.services.paperless.address}:${toString config.services.paperless.port}";
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
