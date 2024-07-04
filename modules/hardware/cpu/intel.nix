{ inputs, ... }:
{
  imports = with inputs; [
    nixos-hardware.nixosModules.common-cpu-intel
  ];

  boot = {
    kernelModules = [ "kvm_intel" ];
    extraModprobeConfig = "options kvm_intel nested=1";
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
