{ inputs, ... }:
{
  imports = with inputs; [
    self.nixosModules.hardware-cpu-amd
  ];

  boot.initrd = {
    availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "virtio_pci"
      "virtio_blk"
    ];
    kernelModules = [ ];
  };
}
