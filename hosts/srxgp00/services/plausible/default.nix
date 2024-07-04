{ config, ... }:
let
  host = "analytics.srx.digital";
in
{
  age.secrets = {
    plausibleAminPassword.file = ./password.age;
    plausibleSecretKey.file = ./secret.age;
    plausibleMailPassword.file = ./mail.age;
  };

  services = {
    plausible = {
      enable = true;
      adminUser = {
        activate = true;
        email = "hostmaster@srx.digital";
        passwordFile = config.age.secrets.plausibleAminPassword.path;
      };
      server = {
        baseUrl = "https://${host}";
        disableRegistration = true;
        secretKeybaseFile = config.age.secrets.plausibleSecretKey.path;
      };
      mail.email = "no-reply@srx.digital";
    };

    nginx.virtualHosts."${host}" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://localhost:${toString config.services.plausible.server.port}";
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
