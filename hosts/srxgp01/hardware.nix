{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "virtio_scsi"
        "sr_mod"
      ];
      kernelModules = [ ];
    };
    loader.systemd-boot.enable = true;
    zfs.devNodes = "/dev/disk/by-uuid";
  };

  services.qemuGuest.enable = true;
}
