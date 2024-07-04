{ config, ... }:
let
  domain = "srx.digital";
  host = "auth.${domain}";
  oidc = "https://id.${domain}/realms/srx";
in
{
  age.secrets.oauth2-proxy.file = ./secrets.age;

  services = {
    oauth2-proxy = {
      enable = true;
      keyFile = config.age.secrets.oauth2-proxy.path;

      nginx.domain = host;
      cookie.domain = ".${domain}";
      email.domains = [ domain ];

      reverseProxy = true;
      passBasicAuth = true;
      setXauthrequest = true;

      provider = "keycloak-oidc";
      clientID = "nginx";
      loginURL = oidc;
      scope = "openid profile email";

      extraConfig = {
        metrics-address = "127.0.0.1:5673";
        oidc-issuer-url = oidc;
        code-challenge-method = "S256";
        session-store-type = "redis";
        redis-connection-url = "redis://${config.services.redis.servers.oauth2-proxy.bind}:${toString config.services.redis.servers.oauth2-proxy.port}/0";
      };
    };

    redis.servers.oauth2-proxy = {
      enable = true;
      port = 6386;
    };

    nginx.virtualHosts."${host}" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = config.services.oauth2-proxy.httpAddress;
    };

    prometheus.scrapeConfigs = [{
      job_name = "oauth2-proxy";
      static_configs = [{ targets = [ config.services.oauth2-proxy.extraConfig.metrics-address ]; }];
    }];

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

  systemd.services.oauth2-proxy = {
    requires = [
      "nginx.service"
      "keycloak.service"
      "redis-oauth2-proxy.service"
    ];
    after = [
      "nginx.service"
      "keycloak.service"
      "redis-oauth2-proxy.service"
    ];
  };
}
