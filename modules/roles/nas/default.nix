{ self, ... }:
{
  imports = [
    self.nixosModules.roles-server
    self.nixosModules.services-dns-avahi
    self.nixosModules.services-storage-samba
    self.nixosModules.services-storage-syncthing
  ];
}
