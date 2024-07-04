{ self, lib, ... }:
{
  imports = [
    self.nixosModules.users
  ];

  users.mutableUsers = lib.mkDefault false;
}
