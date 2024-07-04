{ config, ... }: {
  age.secrets.wifi_client.file = ../wifi_client.age;

  networking = {
    interfaces.wlp0s21f0u2.useDHCP = true;

    wireless = {
      enable = true;
      environmentFile = config.age.secrets.wifi_client.path;

      networks = {
        "skynet".psk = "@PASS_SKYNET@";
        "FRITZ!Box Fon WLAN 7360".psk = "@PASS_WERK2@";
      };
    };
  };

  services.telegraf.extraConfig.inputs.wireless = { };
}
