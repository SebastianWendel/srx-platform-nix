{ inputs, ... }:
{
  imports = with inputs; [
    nixos-hardware.nixosModules.common-cpu-amd-pstate
  ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    extraModprobeConfig = "options kvm_amd nested=1";
    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
