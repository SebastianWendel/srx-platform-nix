{ lib, ... }:
let
  disks = [ "/dev/disk/by-id/wwn-0x5000000000002b6f" ];
in
{
  disko.devices = {
    disk = lib.genAttrs disks (device: {
      name = lib.last (lib.splitString "/" device);
      inherit device;
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            label = "EFI";
            name = "ESP";
            type = "EF00";
            start = "1MiB";
            end = "512MiB";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          SYSTEM = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              passwordFile = "/etc/hostname";
              settings.allowDiscards = true;
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
      };
    });
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
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
