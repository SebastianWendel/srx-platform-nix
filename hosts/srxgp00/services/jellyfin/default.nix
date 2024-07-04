let
  host = "media.srx.digital";
  port = 8096;
in
{
  services.nginx.virtualHosts."${toString host}" = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "http://srxnas00.vpn.srx.dev:${toString port}";
  };

  services.telegraf.extraConfig.inputs = {
    x509_cert = [{
      sources = [ "https://${host}:443" ];
      tags.host = host;
      interval = "10m";
    }];

    http_response = [{
      urls = [ "https://${host}" ];
      tags.host = host;
      interval = "10m";
    }];
  };
}
