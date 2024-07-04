{ pkgs, config, lib, ... }:
{
  imports = [ ./default.nix ];

  virtualisation = {
    oci-containers.backend = "podman";

    podman = {
      enable = true;
      autoPrune.enable = true;

      dockerCompat = true;
      dockerSocket.enable = true;

      extraPackages = with pkgs; [ zfs passt ];
    };
  };

  users.users.telegraf = lib.mkIf config.services.telegraf.enable { extraGroups = [ "podman" ]; };
}
