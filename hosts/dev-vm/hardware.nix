{ self, modulesPath, config, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    self.nixosModules.filesystems-zfs
  ];

  age.secrets.clevisSystem.file = ./clevis.age;

  boot = {
    initrd = {
      systemd = {
        enable = true;
        inherit (config.systemd) network;
      };
      network.enable = true;
      availableKernelModules = [
        "ahci"
        "xhci_pci"
        "virtio_pci"
        "virtio_scsi"
        "sr_mod"
        "virtio_blk"
      ];
      clevis = {
        enable = true;
        useTang = true;
        devices."vda".secretFile = config.age.secrets.clevisSystem.path;
      };
    };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
