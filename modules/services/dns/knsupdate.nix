{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.srx.service.${name};
  name = "knsupdate";
  recordType = ipVersion: if ipVersion == 4 then "A" else "AAAA";
in
{
  options.srx.service.${name} = {
    enable = mkEnableOption ''
      If enabled, ${name} will periodically update
      the dns record.
    '';

    package = mkPackageOption pkgs "knot-dns" { };

    zone = mkOption {
      type = types.str;
      default = config.networking.domain;
      example = "example.com";
      description = ''
        Specifies the zone of the dynamic update
        message.
      '';
    };

    record = mkOption {
      type = types.str;
      default = config.networking.hostName;
      example = "www";
      description = ''
        Specifies the record of the dynamic update
        message.
      '';
    };

    server = mkOption {
      type = types.str;
      default = null;
      example = "ns1.example.com";
      description = ''
        Specifies a receiving server of the dynamic
        update message.

        The name parameter can be either a host name
        or an IP address.
      '';
    };

    port = mkOption {
      type = types.int;
      default = 53;
      description = ''
        Specifies a receiving server port of the
        dynamic update message.
      '';
    };

    ttl = mkOption {
      type = types.int;
      default = 60 * 60;
      description = ''
        Specifies the records TTL in seconds.
      '';
    };

    interval = mkOption {
      type = types.str;
      default = "02:15";
      example = "hourly";
      description = ''
        Update the dns record at this interval.
        Updates by default at 2:15 AM every day.

        The format is described in
        {manpage}`systemd.time(7)`.
      '';
    };

    ipVersions = mkOption {
      type = types.listOf (types.enum [ 4 6 ]);
      default = [ 4 6 ];
      description = ''
        Specifies the Internet Protocol Version
        to use.
      '';
    };

    lockupService = mkOption {
      type = types.str;
      default = "https://checkip.srx.digital/";
      description = ''
        The URL of the IP lookup service. This service returns
        the current public IP address of the machine making
        the request. It supports both IPv4 and IPv6 addresses.
      '';
    };

    keyFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/keys/${name}/keyFile";
      description = ''
        Specifies the TSIG key file to authenticate the request.

        The format is described in
        {manpage}`knot-dns.knsupdate(1)`.
      '';
    };

    user = mkOption {
      type = types.str;
      default = name;
      description = "User under which ${name} runs.";
    };

    group = mkOption {
      type = types.str;
      default = name;
      description = "Group under which ${name} runs.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = lib.foldl'
      (acc: ipVersion: lib.recursiveUpdate acc {
        services."${name}-IPv${toString ipVersion}" = {
          description = "${name} updates DNS zones for dynamic IPv${toString ipVersion} records";
          path = [ pkgs.curl cfg.package ];
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            User = cfg.user;
            Group = cfg.group;
            LoadCredential = "tsig:${cfg.keyFile}";
          };
          script = ''
            IP=$(${getExe pkgs.curl} -s -${toString ipVersion} ${cfg.lockupService})
            if [[ ! -z "$IP" ]]; then
              ${cfg.package}/bin/knsupdate -k ''${CREDENTIALS_DIRECTORY}/tsig << EOT
            server ${cfg.server} ${toString cfg.port}
            zone ${cfg.zone}
            del ${cfg.record}.${cfg.zone}.
            add ${cfg.record}.${cfg.zone}. ${toString cfg.ttl} ${recordType ipVersion} $IP
            send
            EOT
            fi
          '';
        };

        timers."${name}-IPv${toString ipVersion}" = {
          enable = true;
          timerConfig.OnCalendar = cfg.interval;
          wantedBy = [ "timers.target" ];
        };
      })
      { }
      cfg.ipVersions;

    users = optionalAttrs (cfg.user == name) {
      users.${cfg.user} = {
        group = cfg.user;
        isSystemUser = true;
      };

      groups.${cfg.group}.gid = config.users.users.${cfg.user}.uid;
    };
  };
}
