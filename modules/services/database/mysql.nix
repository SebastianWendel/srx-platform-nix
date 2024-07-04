{ lib, config, ... }:
{
  services = {
    mysql = {
      enable = true;
      settings = {
        mysqld = {
          plugin-load-add = [
            "server_audit"
            "ed25519=auth_ed25519"
          ];
        };

        mysqldump = {
          quick = true;
          max_allowed_packet = "16M";
        };
      };
    };

    mysqlBackup.enable = lib.mkIf config.services.mysql.enable true;

    telegraf.extraConfig.inputs.mysql = lib.mkIf config.services.telegraf.enable {
      servers = [ "tcp(127.0.0.1:3306)/" ];
      metric_version = 2;
    };
  };
}
