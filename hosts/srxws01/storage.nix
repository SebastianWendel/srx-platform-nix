{ lib, ... }:
let
  disks = [ "/dev/sda" ];
  compression = "zstd";
  rootFsOptions = {
    acltype = "posixacl";
    dnodesize = "auto";
    normalization = "formD";
    xattr = "sa";
    relatime = "on";
    canmount = "off";
    mountpoint = "none";
    inherit compression;
    "com.sun:auto-snapshot" = "false";
  };
  passwordFile = "/etc/hostname";
  system = lib.genAttrs disks
    (device:
      let
        name = builtins.replaceStrings [ "_" ] [ "-" ] (lib.lists.last (builtins.split "/" device));
      in
      {
        type = "disk";
        inherit name device;
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
            };
            esp = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            system = {
              size = "100%";
              content = {
                type = "luks";
                inherit name;
                content = {
                  type = "zfs";
                  pool = "system";
                };
                inherit passwordFile;
                settings.allowDiscards = true;
              };
            };
          };
        };
      });
  default = mountpoint: {
    type = "zfs_fs";
    options = {
      inherit mountpoint;
    };
    inherit mountpoint;
  };
  auto_snapshot = mountpoint: {
    type = "zfs_fs";
    options = {
      inherit mountpoint;
      "com.sun:auto-snapshot" = "true";
    };
    inherit mountpoint;
  };
  can_not_mount = {
    type = "zfs_fs";
    options = {
      canmount = "off";
      mountpoint = "none";
    };
    mountpoint = null;
    mountOptions = [ ];
  };
in
{
  disko.devices = {
    disk = system;
    zpool = {
      system = {
        type = "zpool";
        options = {
          ashift = "12";
          autotrim = "on";
        };
        inherit rootFsOptions;
        mountpoint = null;
        datasets = {
          "reserved" = {
            type = "zfs_fs";
            options = {
              canmount = "off";
              mountpoint = "none";
              refreservation = "10GiB";
            };
            mountpoint = null;
            mountOptions = [ ];
          };
          "nixos" = can_not_mount;
          "nixos/etc" = default "/etc";
          "nixos/nix" = default "/nix";
          "user" = can_not_mount;
          "user/root" = default "/root";
          "user/home" = auto_snapshot "/home";
          "data" = can_not_mount;
          "data/lib" = auto_snapshot "/var/lib";
          "data/log" = default "/var/log";
          "data/cache" = default "/var/cache";
          "data/backup" = default "/var/backup";
        };
      };
    };
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "size=1G"
          "mode=755"
          "noatime"
        ];
      };
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [ "size=1G" ];
      };
    };
  };
}
