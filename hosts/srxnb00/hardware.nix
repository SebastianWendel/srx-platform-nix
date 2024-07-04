{ inputs, config, modulesPath, ... }:
{
  imports = with inputs; [
    (modulesPath + "/installer/scan/not-detected.nix")
    self.nixosModules.hardware
    self.nixosModules.hardware-laptop
    self.nixosModules.hardware-cpu-amd
    self.nixosModules.hardware-gpu-amd
    self.nixosModules.filesystems-zfs
    self.nixosModules.hardware-security-secureboot
  ];

  age.secrets.clevis.file = ./clevis.age;

  boot = {
    initrd = {
      systemd = {
        enable = true;
        inherit (config.systemd) network;
      };
      network = {
        enable = true;
        ssh = {
          enable = true;
          authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
          port = 2222;
          hostKeys = [ /etc/ssh/ssh_host_ed25519_key_initrd ];
        };
      };
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
        "r8169"
      ];
      kernelModules = [ ];
      clevis = {
        enable = true;
        devices."nvme-eui.002538ba11c0820c".secretFile = config.age.secrets.clevis.path;
      };
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
