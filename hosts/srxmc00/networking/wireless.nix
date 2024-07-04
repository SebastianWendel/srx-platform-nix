{ config, ... }:
{
  age.secrets.wifiClient.file = ../wifi_client.age;

  networking.wireless = {
    enable = true;
    networks."@SSID@".psk = "@PASSWD@";
    environmentFile = config.age.secrets.wifiClient.path;
  };

  services.telegraf.extraConfig.inputs.wireless = { };
}
