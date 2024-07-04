{ self, inputs, config, modulesPath, ... }:
{
  imports = with inputs; [
    (modulesPath + "/installer/scan/not-detected.nix")
    self.nixosModules.hardware
    self.nixosModules.hardware-cpu-intel
    # self.nixosModules.hardware-gpu-intel
    self.nixosModules.hardware-security-secureboot
    self.nixosModules.filesystems-zfs
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
      network.enable = true;
      clevis.enable = true;
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  powerManagement.cpuFreqGovernor = "powersave";
}
