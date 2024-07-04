{ lib, config, ... }:
{
  boot = {
    initrd.supportedFilesystems = lib.mkDefault [ "zfs" ];
    kernelPackages = lib.mkForce config.boot.zfs.package.latestCompatibleLinuxPackages;
    supportedFilesystems = [ "zfs" ];
  };

  services = {
    zfs = {
      autoScrub = {
        enable = true;
        interval = "weekly";
      };

      trim = {
        enable = true;
        interval = "weekly";
      };
    };

    telegraf.extraConfig.inputs.zfs = lib.mkIf config.services.telegraf.enable { };
  };
}
