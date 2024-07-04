{ inputs, modulesPath, config, ... }:
{
  imports = with inputs; [
    (modulesPath + "/installer/scan/not-detected.nix")
    self.nixosModules.hardware
    self.nixosModules.hardware-cpu-intel
    self.nixosModules.hardware-gpu-amd
    nixos-hardware.nixosModules.common-cpu-intel-sandy-bridge
  ];

  age.secrets.clevis.file = ./clevis.age;

  boot = {
    initrd = {
      systemd = {
        enable = true;
        inherit (config.systemd) network;
      };
      availableKernelModules = [
        "ahci"
        "ehci_pci"
        "nvme"
        "usb_storage"
        "usbhid"
        "xhci_pci"
        "r8169"
      ];
      kernelModules = [ ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
          port = 2222;
          hostKeys = [ /etc/ssh/ssh_host_ed25519_key_initrd ];
        };
      };
      # clevis = {
      #   enable = true;
      #   useTang = true;
      #   devices."sda".secretFile = config.age.secrets.clevis.path;
      # };
    };
    loader = {
      grub = {
        enable = true;
        device = "/dev/disk/by-id/wwn-0x500253887015385a";
      };
      efi.canTouchEfiVariables = true;
    };
  };
}
