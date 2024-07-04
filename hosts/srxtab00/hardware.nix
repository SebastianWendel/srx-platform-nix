{ inputs, lib, modulesPath, pkgs, ... }:
{
  imports = with inputs; [
    (modulesPath + "/installer/scan/not-detected.nix")
    self.nixosModules.hardware
    self.nixosModules.hardware-cpu-intel
    self.nixosModules.hardware-gpu-intel
    self.nixosModules.hardware-security-secureboot
    nixos-hardware.nixosModules.microsoft-surface-go
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "rtsx_pci_sdmmc"
        "usbhid"
        "xhci_pci"
      ];
      kernelModules = [ ];
      luks.devices.system = {
        device = "/dev/disk/by-uuid/1f66cad5-a9ed-4ca1-b0c2-49436a762ee5";
        allowDiscards = true;
        bypassWorkqueues = true;
      };
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # use the mainline kernel, since wireplumber segfaults with the nixos-hardware version
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  };

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "noatime"
        "size=20%"
        "mode=755"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/9A9A-B16F";
      fsType = "vfat";
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/ac0096c0-3e16-4f29-8730-581cff1b0d91";
      fsType = "btrfs";
      options = [
        "noatime"
        "discard=async"
        "subvol=nix"
      ];
      neededForBoot = true;
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/ac0096c0-3e16-4f29-8730-581cff1b0d91";
      fsType = "btrfs";
      options = [
        "noatime"
        "discard=async"
        "subvol=persist"
      ];
      neededForBoot = true;
    };
  };

  age.identityPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

  environment.persistence."/persist" = {
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
    directories = [
      "/etc/secureboot"
      "/home"
      "/etc/NetworkManager"
      "/var/log"
      "/var/lib"
    ];
  };

  services.thermald.enable = lib.mkForce false;
}
