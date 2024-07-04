{ config, ... }:
{
  age.secrets.passwordRoot.file = ./password.age;

  users.users.root = {
    openssh.authorizedKeys.keys = config.users.users.crstl.openssh.authorizedKeys.keys;
    hashedPasswordFile = config.age.secrets.passwordRoot.path;
  };

  home-manager.users.root.home = {
    username = config.users.users.root.name;
    stateVersion = "23.11";
  };
}
