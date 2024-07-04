{ config, pkgs, lib, ... }:
{
  age.secrets.sshPrivateAutomat = {
    file = ./ssh-private.age;
    owner = "${config.users.users.automat.group}";
  };

  users = {
    users.automat = {
      uid = lib.mkForce 1080;
      group = "automat";
      description = lib.mkForce "Automat build user";
      createHome = true;
      home = "/var/lib/automat";
      extraGroups =
        [ "users" ]
        ++ lib.optionals config.virtualisation.libvirtd.enable [ "libvirtd" ]
        ++ lib.optionals config.virtualisation.docker.enable [ "docker" ]
        ++ lib.optionals config.virtualisation.podman.enable [ "podman" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMm1kAmSNQBTBhhod951FNhPwXeIEz9It7NmHZ2d1LqJ"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPGG175tUqyZmN5a2ImRrEhZA5VtKdyxQMPJmymNCxGd"
      ];
      isNormalUser = true;
      shell = pkgs.bashInteractive;
    };

    groups.automat.gid = lib.mkForce config.users.users.automat.uid;
  };

  nix.settings.trusted-users = [ "automat" ];

  services.displayManager.hiddenUsers = [ config.users.users.automat.name ];

  home-manager = {
    users.automat = {
      home = {
        username = config.users.users.automat.name;
        stateVersion = "22.05";
      };

      programs.home-manager.enable = true;
    };
  };
}
