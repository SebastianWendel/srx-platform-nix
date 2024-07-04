{ lib, config, ... }:
{
  services.moonraker = {
    enable = true;
    group = "${config.services.klipper.group}";

    allowSystemControl = true;

    settings = {
      server = {
        max_upload_size = 16384;
      };
      octoprint_compat = {
        enable_ufp = true;
        webcam_enabled = true;
      };
      zeroconf = { };
      history = { };
      authorization = {
        force_logins = true;
        cors_domains = [
          "*.local"
          "*.lan"
          "*://localhost:*"
          "http://*.lan"
          "http://*.local"
        ];
        trusted_clients = [
          "10.0.0.0/8"
          "127.0.0.0/8"
          "169.254.0.0/16"
          "172.16.0.0/12"
          "192.168.1.0/24"
          "FE80::/10"
          "::1/128"
        ];
      };
    };
  };

  security.polkit.enable = lib.mkIf config.services.moonraker.allowSystemControl true;

  networking.firewall.allowedTCPPorts = [ config.services.moonraker.port ];
}
