{ pkgs, ... }:
{
  services = {
    mysql = {
      enable = true;
      package = pkgs.mariadb;
    };

    mysqlBackup = {
      enable = true;
      calendar = "05:00:00";
    };
  };
}
