{ lib, ... }:
{
  services.clamav = {
    scanner = {
      enable = lib.mkDefault true;
      interval = "daily";
    };
    updater.enable = lib.mkDefault true;
    fangfrisch.enable = lib.mkDefault true;
    daemon.enable = lib.mkDefault true;
  };
}
