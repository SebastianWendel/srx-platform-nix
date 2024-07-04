{ self, pkgs, ... }:
{
  imports = [
    self.nixosModules.roles-desktop
    self.nixosModules.hardware-security-yubikey
    # self.nixosModules.hardware-security-nitrokey
    self.nixosModules.services-container-podman
    self.nixosModules.services-virtualisation-libvirt
    self.nixosModules.services-virtualisation-microvm
  ];

  programs = {
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
    kdeconnect.enable = true;
  };
}
