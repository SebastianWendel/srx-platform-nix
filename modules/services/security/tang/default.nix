{ pkgs, ... }:
let
  port = 7654;
in
{
  services.tang = {
    enable = true;
    listenStream = [
      "7654"
      # "${host}"
    ];
    ipAddressAllow = [
      "0.0.0.0/0"
      # "10.80.0.0/24"
    ];
  };


  environment.systemPackages = with pkgs; [
    cryptsetup
    clevis
    tang
    jose
  ];

  networking.firewall.allowedTCPPorts = [ port ];

  # services.nginx.virtualHosts.${host} = {
  #   forceSSL = true;
  #   enableACME = true;
  #   locations."/".proxyPass = "http://${bind}";
  # };
}
