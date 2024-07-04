{ lib, pkgs, ... }:
{
  services = {
    postgresql.package = lib.mkForce pkgs.postgresql_14;

    postgresqlBackup = {
      enable = true;
      startAt = "*-*-* 05:00:00";
      compression = "none";
    };

    prometheus.exporters.postgres.enable = true;
  };
}
