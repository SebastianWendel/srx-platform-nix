{ pkgs, lib, inputs, config, ... }:

with lib;
with inputs;

let
  cfg = config.srx.service.dns;

  identity = "${config.services.knot.settings.server.identity}.";
  primary = config.srx.service.dns.defaults.SOA.nameServer;

  writeZoneFile = zone: records: pkgs.writeText "${zone}.zone" (
    dns.lib.toString zone records
  );

  knotZones = lib.attrsets.mapAttrs
    (zone: records: {
      file = lib.mkIf (identity == primary) (writeZoneFile zone records);
      template = lib.mkIf (identity != primary) "slave";
    })
    cfg.zones;
in
{
  options.srx.service.dns = {
    zones = mkOption {
      type = types.attrs;
      default = { };
      description = "";
    };

    defaults = mkOption {
      type = types.attrs;
      default = { };
      description = "";
    };

    mergeHosts = mkOption {
      type = types.bool;
      default = true;
      description = "";
    };
  };

  config = {
    services.knot.settings.zone = lib.mkIf config.services.knot.enable knotZones;
  };
}
