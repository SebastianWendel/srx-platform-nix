{ pkgs, config, lib, ... }:
{
  imports = [
    ./auth.nix
    ./http.nix
    ./zones.nix
    ./lovelace
  ];

  users.users.hass = {
    extraGroups =
      [ "dialout" ]
      ++ lib.optionals config.hardware.i2c.enable [ "i2c" ]
      ++ lib.optionals config.hardware.bluetooth.enable [ "lp" ]
      ++ lib.optionals config.sound.enable [ "audio" ];
  };

  # age.secrets.homeAssistantSecrets.file = ./home-assistant-s2ecrets.age;

  services = {
    home-assistant = {
      enable = true;
      package =
        (pkgs.home-assistant.override {
          # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/home-assistant/component-packages.nix
          extraComponents = [
            "auth"
            "backup"
            "esphome"
            "lovelace"
            "matrix"
            "mqtt"
            "network"
            "zeroconf"
          ];
          extraPackages = py: with py; [ psycopg2 pip ];
        }).overrideAttrs { doInstallCheck = false; };
      config = {
        homeassistant = {
          external_url = "https://home.srx.digital";
          internal_url = "https://home.vpn.srx.dev";
        };
        default_config = { };
        logger = {
          default = "info";
        };
        mqtt = {
          broker = "localhost";
          port = 1883;
          discovery = true;
        };
        backup = { };
        bluetooth = { };
        dhcp = { };
        discovery = { };
        esphome = { };
        frontend = { };
        history = { };
        prometheus = { };
        system_health = { };
        system_log = { };
        wake_on_lan = { };
        webhook = { };
        zeroconf = { };
        recorder = {
          db_url = "postgresql://@/hass";
          purge_keep_days = 90;
        };
      };
    };

    postgresql = {
      enable = true;
      ensureDatabases = [ "hass" ];
      ensureUsers = [
        {
          name = "hass";
          ensureDBOwnership = true;
        }
      ];
    };

    postgresqlBackup = {
      enable = true;
      databases = [ "hass" ];
    };
  };
}
