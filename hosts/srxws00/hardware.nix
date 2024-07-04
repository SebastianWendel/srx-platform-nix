{ inputs, config, modulesPath, ... }:
{
  imports = with inputs; [
    (modulesPath + "/installer/scan/not-detected.nix")
    self.nixosModules.hardware
    self.nixosModules.hardware-cpu-intel
    self.nixosModules.hardware-gpu-amd
    self.nixosModules.hardware-security-secureboot
    nixos-hardware.nixosModules.supermicro-x10sll-f
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ahci"
        "ehci_pci"
        "nvme"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];
      kernelModules = [ ];
      systemd = {
        enable = true;
        inherit (config.systemd) network;
      };
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
