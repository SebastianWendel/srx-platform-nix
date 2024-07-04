{ lib, config, ... }:
{
  services.prometheus = {
    exporters = {
      knot.enable = true;

      dnssec = {
        enable = true;
        configuration.records = lib.attrsets.mapAttrsToList
          (zone: _: {
            inherit zone;
            record = "@";
            type = "SOA";
          })
          config.srx.service.dns.zones;
      };
    };

    scrapeConfigs = [
      {
        job_name = "knot";
        static_configs = [{
          targets = lib.lists.forEach config.srx.service.dns.defaults.NS (
            host: toString host + ":${toString config.services.prometheus.exporters.knot.port}"
          );
        }];
      }
      {
        job_name = "dnssec";
        static_configs = [{
          targets = lib.lists.forEach config.srx.service.dns.defaults.NS (
            host: toString host + ":${toString config.services.prometheus.exporters.dnssec.port}"
          );
        }];
      }
    ];
  };
}
