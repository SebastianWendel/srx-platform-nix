{ pkgs, modulesPath, ... }:
let
  nixosNetboot =
    let
      inherit ((import (pkgs.path + "/nixos/lib/eval-config.nix") {
        system = "x86_64-linux";
        modules = [{
          imports = [
            (modulesPath + "/installer/netboot/netboot-base.nix")
            ./config.nix
          ];
        }];
      }).config.system) build;
    in
    pkgs.symlinkJoin {
      name = "nixos-netboot";
      paths = with build; [
        kernel
        netbootRamdisk
        netbootIpxeScript
      ];
    };

  ipxeMenu = pkgs.writeTextDir "boot.php" ''
    #!ipxe

    echo ip-address:      ''${net0/ip}
    echo ip-subnet-mask:  ''${net0/netmask}
    echo boot-file:       ''${filename}

    :menu
    menu iPXE boot menu

    item disk Boot Disk
    item nixos-netboot Boot NixOS Netboot
    item netboot-xyz Boot Netboot.xyz
    item shell Start iPXE shell
    item off Shutdown
    item reset Reboot

    choose --default nixos-netboot --timeout 5000 res || goto menu
    goto ''${res}

    :disk
    exit

    :nixos-netboot
    chain --autofree images/nixos-netboot/netboot.ipxe || goto menu

    :netboot-xyz
    chain --autofree ipxe/netboot-xyz.ipxe || goto menu

    :shell
    shell || goto menu

    :off
    echo power off system
    sleep 10 || goto menu
    poweroff

    :reset
    reboot
  '';

  ipxeNetbootXyz = pkgs.writeTextDir "netboot-xyz.ipxe" ''
    #!ipxe
    chain --autofree https://boot.netboot.xyz/
  '';

  ipxeCollection = pkgs.symlinkJoin {
    name = "ipxe";
    paths = [ ipxeNetbootXyz ];
  };

  netbootWebRoot = pkgs.runCommand "webroot" { } ''
    mkdir -pv $out/images
    ln -s ${ipxeMenu}/boot.php $out/boot.php
    ln -s ${nixosNetboot} $out/images/nixos-netboot
    ln -s ${ipxeCollection} $out/ipxe
  '';
in
{
  services.nginx.virtualHosts."netboot.srx.digital" = {
    forceSSL = true;
    enableACME = true;
    locations."/".root = netbootWebRoot;
  };
}
