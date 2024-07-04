let
  host = "srx81.de";
in
{
  services = {
    nginx.virtualHosts."${host}" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = { };
    };

    telegraf.extraConfig.inputs = {
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
  };
}
