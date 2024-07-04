{
  services = {
    fluidd = {
      enable = true;

      nginx = {
        default = true;
        locations."/webcam".proxyPass = "http://127.0.0.1:8080/stream";
      };
    };

    nginx.clientMaxBodySize = "1000m";
  };

  networking.firewall = {
    allowedTCPPorts = [ 80 ];
    allowedUDPPorts = [ 80 ];
  };
}
