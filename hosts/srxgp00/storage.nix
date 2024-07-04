{ lib, ... }:
let
  pool = "rpool";
  disks = [ "/dev/nvme0n1" "/dev/nvme1n1" ];
in
{
  disko.devices = {
    disk = lib.genAttrs disks (device: {
      type = "disk";
      inherit device;
      content = {
        type = "gpt";
        partitions = {
          BOOT = {
            size = "1M";
            type = "EF02";
          };
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              name = "boot";
              type = "mdraid";
            };
          };
          SYSTEM = {
            size = "100%";
            content = {
              inherit pool;
              type = "zfs";
            };
          };
        };
      };
    });
    zpool = {
      ${pool} = {
        type = "zpool";
        mode = "mirror";
        options = {
          ashift = "12";
          autotrim = "on";
        };
        rootFsOptions = {
          acltype = "posixacl";
          compression = "zstd";
          normalization = "formD";
          dnodesize = "auto";
          relatime = "on";
          xattr = "sa";
          canmount = "off";
          mountpoint = "none";
          "com.sun:auto-snapshot" = "false";
        };
        mountpoint = null;
        datasets =
          let
            default = mountpoint: {
              type = "zfs_fs";
              inherit mountpoint;
              mountOptions = [ "X-mount.mkdir" ];
            };
            can_not_mount = {
              type = "zfs_fs";
              options = {
                canmount = lib.mkForce "off";
                mountpoint = lib.mkForce "none";
              };
              mountpoint = lib.mkForce null;
              mountOptions = lib.mkForce [ ];
            };
          in
          {
            "reserved" = {
              type = "zfs_fs";
              options = {
                refreservation = "10GiB";
                canmount = lib.mkForce "off";
                mountpoint = lib.mkForce "none";
              };
              mountpoint = lib.mkForce null;
            };
            "nixos" = can_not_mount;
            "nixos/etc" = default "/etc";
            "nixos/nix" = default "/nix";
            "user" = can_not_mount;
            "user/root" = default "/root";
            "user/home" = {
              type = "zfs_fs";
              options."com.sun:auto-snapshot" = "true";
              mountpoint = "/home";
              mountOptions = [ "X-mount.mkdir" ];
            };
            "data" = can_not_mount;
            "data/log" = default "/var/log";
            "data/lib" = {
              type = "zfs_fs";
              options."com.sun:auto-snapshot" = "true";
              mountpoint = "/var/lib";
              mountOptions = [ "X-mount.mkdir" ];
            };
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
        ];
      };
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [ "size=1G" ];
      };
    };
    mdadm = {
      boot = {
        type = "mdadm";
        level = 1;
        metadata = "1.0";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
        };
      };
    };
  };

  virtualisation.containers.storage.settings.storage = {
    driver = lib.mkForce "zfs";
    graphroot = "/var/lib/containers/storage";
    runroot = "/run/containers/storage";
  };
}
