{ lib, config, ... }:
{
  imports = [ ./default.nix ];

  virtualisation = {
    oci-containers.backend = "docker";

    docker = {
      enable = true;
      storageDriver = config.virtualisation.containers.storage.settings.storage.driver;
      autoPrune.enable = true;
    };
  };

  services.telegraf.extraConfig.inputs.docker = lib.mkIf config.services.telegraf.enable { };

  users.users.telegraf = lib.mkIf config.services.telegraf.enable {
    extraGroups = lib.optionals config.virtualisation.docker.enable [ "docker" ];
  };
}
