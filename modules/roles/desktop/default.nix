{ self, inputs, ... }:
{
  imports = with inputs; [
    self.nixosModules.hardware-sound-pipewire
    self.nixosModules.roles-core
    self.nixosModules.services-dns-avahi
    srvos.nixosModules.desktop
    nixos-hardware.nixosModules.common-hidpi

    ./system
    ./display-manager
    ./desktop-manager/gnome.nix
    ./window-manager
    ./office
  ];
}
