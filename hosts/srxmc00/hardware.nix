{ lib, config, self, inputs, ... }:
{
  imports = with inputs; [
    self.nixosModules.hardware
    self.nixosModules.hardware-cpu-intel
    # self.nixosModules.hardware-gpu-intel
    self.nixosModules.hardware-bluetooth
    self.nixosModules.hardware-security-secureboot
    srvos.nixosModules.mixins-systemd-boot
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "nvme"
        "sd_mod"
        "usb_storage"
        "usbhid"
        "xhci_pci"
        "r8169"
      ];
      kernelModules = [ ];
      systemd = {
        enable = true;
        inherit (config.systemd) network;
      };
      clevis.enable = true;
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = "performance";
}
