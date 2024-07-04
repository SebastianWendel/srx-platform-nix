{ lib, ... }:
let
  disks = [ "/dev/vda" ];
in
{
  disko.devices = {
    disk = lib.genAttrs disks (device: {
      name = lib.last (lib.splitString "/" device);
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
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          SYSTEM = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "discard=async"
                    "noatime"
                  ];
                };
                "/var" = {
                  mountpoint = "/var";
                  mountOptions = [
                    "compress=zstd"
                    "discard=async"
                    "noatime"
                  ];
                };
                "/etc" = {
                  mountpoint = "/etc";
                  mountOptions = [
                    "compress=zstd"
                    "discard=async"
                    "noatime"
                  ];
                };
                "/root" = {
                  mountpoint = "/root";
                  mountOptions = [
                    "compress=zstd"
                    "discard=async"
                    "noatime"
                  ];
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd"
                    "discard=async"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    });
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=512M"
          "mode=755"
          "noatime"
        ];
      };
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [ "size=512M" ];
      };
    };
  };
}
