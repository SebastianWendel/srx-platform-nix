{ config, ... }:
let
  host = "status.srx.digital";
  hosts = [
    "srxgp00.vpn.srx.dev"
    "srxgp01.vpn.srx.dev"
    "srxgp02.vpn.srx.dev"
    "srxk8s00.vpn.srx.dev"
    "srxnas00.vpn.srx.dev"
    "srxnas01.vpn.srx.dev"
    "copepod.vpn.srx.dev"
    "diatome.vpn.srx.dev"
    "opd00.vpn.srx.dev"
  ];
  openwrt = [
    "srxap01.op.hq.hh.srx.digital"
    "srxfw01.op.hq.hh.srx.digital"
  ];
in
{
  services = {
    prometheus = {
      enable = true;
      extraFlags = [ "--storage.tsdb.retention.time=30d" ];
      scrapeConfigs = [
        {
          job_name = "prometheus";
          static_configs = [{
            targets = [
              "srxgp00.vpn.srx.dev:${toString config.services.prometheus.port}"
            ];
          }];
        }
        {
          job_name = "node";
          static_configs = [
            {
              targets = builtins.concatMap
                (name: [
                  "${name}:${toString config.services.prometheus.exporters.node.port}"
                ])
                hosts;
            }
          ];
        }
        {
          job_name = "telegraf";
          static_configs = [{
            targets = builtins.concatMap (name: [ "${name}:9273" ]) hosts;
          }];
        }
        {
          job_name = "openwrt";
          static_configs = [{
            targets = builtins.concatMap (name: [ "${name}:9273" ]) openwrt;
          }];
        }
      ];
    };

    nginx.virtualHosts."${host}" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
    };

    oauth2-proxy.nginx.virtualHosts."${host}" = {
      allowed_email_domains = [ "srx.digital" ];
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

    grafana.provision.datasources.settings.datasources = [{
      name = "Prometheus";
      type = "prometheus";
      access = "proxy";
      url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
      isDefault = true;
    }];
  };
}
