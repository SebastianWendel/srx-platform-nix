{ lib, pkgs, ... }:
{
  console.earlySetup = lib.mkForce true;

  boot = {
    tmp = {
      useTmpfs = lib.mkDefault true;
      cleanOnBoot = lib.mkDefault true;
    };

    kernel.sysctl."vm.swappiness" = 10;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    initrd.systemd = {
      initrdBin = with pkgs; [
        iproute2
        iputils
        keyutils
        tor
        wpa_supplicant
      ];

      packages = with pkgs; [
        tor
        wpa_supplicant
      ];
    };
  };
}
