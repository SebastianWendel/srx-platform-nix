{ lib, ... }:
let
  disks = {
    system = [ "/dev/disk/by-id/nvme-eui.00253855015004a5" ];
    data = [
      "/dev/disk/by-id/wwn-0x5000c50065b38b37"
      "/dev/disk/by-id/wwn-0x5000c5007296fdf7"
      "/dev/disk/by-id/wwn-0x5000c5007b7125de"
      "/dev/disk/by-id/wwn-0x5000c5007b712c7e"
    ];
  };
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
  system = lib.genAttrs disks.system
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
  raid = lib.genAttrs disks.data
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
            raid = {
              size = "100%";
              content = {
                type = "luks";
                inherit name;
                content = {
                  type = "zfs";
                  pool = "raid";
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
    disk = system // raid;
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
      raid = {
        type = "zpool";
        mode = "raidz";
        options = {
          ashift = "12";
          autotrim = "on";
        };
        inherit rootFsOptions;
        mountpoint = null;
        datasets = {
          "data" = can_not_mount;
          "data/backups" = default "/srv/backups";
          "data/home" = auto_snapshot "/srv/home";
          "data/documents" = auto_snapshot "/srv/documents";
          "data/movies" = default "/srv/movies";
          "data/music" = default "/srv/music";
          "data/pictures" = default "/srv/pictures";
          "data/videos" = default "/srv/videos";
          "data/public" = default "/srv/public";
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
