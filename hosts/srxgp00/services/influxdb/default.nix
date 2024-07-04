{ pkgs, config, ... }:
let
  host = "tsdb.srx.digital";
in
{
  environment.systemPackages = with pkgs; [ influxdb2-cli ];

  services = {
    influxdb2 = {
      enable = true;
      settings = {
        reporting-disabled = true;
        http-bind-address = "127.0.0.1:8086";
      };
    };

    grafana.provision.datasources.settings.datasources = [{
      type = "influxdb";
      name = "influxdb";
      url = "http://${config.services.influxdb2.settings.http-bind-address}";
    }];

    nginx.virtualHosts."${host}" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://${config.services.influxdb2.settings.http-bind-address}";
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
