{ config, ... }:
{
  services.prometheus.scrapeConfigs = [{
    job_name = "apcupsd";
    static_configs = [{ targets = [ "srxnas00.vpn.srx.dev:${toString config.services.prometheus.exporters.apcupsd.port}" ]; }];
  }];
}
