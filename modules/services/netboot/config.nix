{ lib, pkgs, config, ... }:
{
  imports = [
    ../../roles/core/fail2ban.nix
    ../../roles/core/zsh.nix
    ../../roles/core/editor.nix
  ];

  boot.supportedFilesystems = [ "zfs" "btrfs" ];

  services = {
    openssh.enable = true;
    rpcbind.enable = true;
    getty.autologinUser = lib.mkForce null;
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB6vk3k1p6YMsGLFQ/xABLYK/VJicywkf1MJawnN7oXU"
  ];

  environment.systemPackages = with pkgs; [
    ethtool
    iotop
    iperf
    lsof
    nvme-cli
    pciutils
    socat
    sysstat
    tcpdump
    usbutils
    vnstat
  ];

  system.stateVersion = config.system.nixos.release;
}
