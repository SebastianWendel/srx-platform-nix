{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "sr_mod"
        "virtio_scsi"
        "xhci_pci"
      ];
      kernelModules = [ ];
    };
    loader.systemd-boot.enable = true;
  };
}
