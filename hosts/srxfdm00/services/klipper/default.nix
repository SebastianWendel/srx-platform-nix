{ lib, config, ... }:
{
  services.klipper = {
    enable = true;
    octoprintIntegration = lib.mkIf config.services.octoprint.enable true;
    user = lib.mkForce "klipper";
    group = lib.mkForce "klipper";
    firmwares.mcu = {
      enable = true;
      serial = /dev/serial/by-id/usb-Klipper_stm32f446xx_360015001750535556323420-if00;
      configFile = ./firmware.ini;
      enableKlipperFlash = true;
    };
    configFile = ./settings.cfg;
  };

  users = {
    groups.${config.services.klipper.group} = { };
    users.${config.services.klipper.user} = {
      group = "${config.services.klipper.group}";
      extraGroups = [ "dialout" ];
      isSystemUser = true;
    };
  };

  security.sudo.extraRules = [{
    commands = [{
      command = "/run/current-system/sw/bin/poweroff";
      options = [ "NOPASSWD" ];
    }];
    groups = [ config.services.klipper.group ];
  }];
}
