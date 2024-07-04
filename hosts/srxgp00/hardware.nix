{ self, inputs, modulesPath, ... }:
{
  imports = with inputs; [
    (modulesPath + "/installer/scan/not-detected.nix")
    self.nixosModules.hardware
    self.nixosModules.hardware-cpu-amd
    srvos.nixosModules.hardware-hetzner-online-amd
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
      ];
      kernelModules = [ ];
    };
    swraid.enable = true;
    zfs.devNodes = "/dev/disk/by-uuid";
  };
}
