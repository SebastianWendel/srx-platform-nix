{ lib, pkgs, config, ... }:
{
  services = {
    postgresql = {
      enable = true;
      enableTCPIP = true;
      package = pkgs.postgresql_14;
      settings = {
        logging_collector = true;
        log_connections = true;
        log_disconnections = true;
      };
    };

    postgresqlBackup = {
      enable = true;
      backupAll = true;
      compression = "zstd";
    };

    prometheus = {
      exporters.postgres.enable = true;
      scrapeConfigs = [
        {
          job_name = "postgresql";
          static_configs = [
            { targets = [ "localhost:${toString config.services.prometheus.exporters.postgres.port}" ]; }
          ];
        }
      ];
    };

    telegraf.extraConfig.inputs.postgresql = lib.mkIf config.services.telegraf.enable { };
  };

  users.users.telegraf = lib.mkIf config.services.telegraf.enable { extraGroups = [ "postgres" ]; };
}
