{ config, pkgs, ... }:
{
  users = {
    users.service = {
      uid = 1010;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIClhBg2rQEhXMkM97dRrWGAm94I1dnI553qsk5LD9nH4"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwyxpc0pVB46j1k5VCSabvI4TUADvAabnxlE5+D5o2l"
      ];
      shell = pkgs.bashInteractive;
      isNormalUser = true;
    };

    groups.service.gid = config.users.users.service.uid;
  };

  home-manager = {
    users.service = {
      home = {
        username = config.users.users.service.name;
        stateVersion = "22.05";
      };

      programs.home-manager.enable = true;
    };
  };

  services.displayManager.hiddenUsers = [ config.users.users.service.name ];
}
