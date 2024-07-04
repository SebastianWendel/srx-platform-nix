{ inputs, config, modulesPath, ... }:
{
  imports = with inputs; [
    (modulesPath + "/installer/scan/not-detected.nix")
    self.nixosModules.hardware
    self.nixosModules.hardware-cpu-intel
    self.nixosModules.hardware-security-secureboot
    self.nixosModules.filesystems-zfs
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
        "ahci"
        "nvme"
        "sd_mod"
        "usb_storage"
        "usbhid"
        "xhci_pci"
        "r8169"
      ];
      kernelModules = [ ];
      clevis = {
        enable = true;
        useTang = true;
        devices = {
          "nvme-eui.0025385a81b4239b".secretFile = config.age.secrets.clevis.path;
          "wwn-0x5000c500d6b1b870".secretFile = config.age.secrets.clevis.path;
        };
      };
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  powerManagement.cpuFreqGovernor = "powersave";
}
