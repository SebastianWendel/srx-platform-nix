{ self, lib, pkgs, config, ... }:
{
  imports = [
    self.nixosModules.services-container-docker
  ];

  age.secrets.giteaRunnerTokenSRX = {
    file = ./runnerToken.age;
    owner = config.users.users.gitea-runner.name;
  };

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;

    instances."${config.networking.hostName}" = {
      enable = true;
      name = config.networking.hostName;
      url = config.services.forgejo.settings.server.ROOT_URL;
      tokenFile = config.age.secrets.giteaRunnerTokenSRX.path;

      hostPackages = with pkgs; [
        coreutils
        direnv
        git-lfs
        gitFull
        nixVersions.latest
        nodejs
        opentofu
      ];

      labels = [ "ubuntu-latest" ];
    };
  };

  users.groups.gitea-runner = { };
  users.users.gitea-runner = {
    group = "gitea-runner";
    extraGroups = [ "docker" ];
    isSystemUser = true;
  };

  systemd.services."gitea-runner-${config.networking.hostName}" = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      Group = config.users.users.gitea-runner.group;
      Restart = lib.mkForce "always";
    };
    ## FIXME: act_runner level=error msg="fail to invoke Declare" error="unavailable: dial tcp [2a01:4f9:6b:2573::1]:443: connect: connection refused"
    requires = [
      "nginx.service"
      "forgejo.service"
    ];
    after = [
      "network.target"
      "nginx.service"
      "forgejo.service"
    ];
  };
}
