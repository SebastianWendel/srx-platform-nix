{ pkgs, ... }:
let
  host = "checkip.srx.digital";
in
{
  services = {
    nginx = {
      additionalModules = [ pkgs.nginxModules.echo ];
      virtualHosts."${host}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".extraConfig = ''
          default_type  text/plain;
          echo $remote_addr;
        '';
      };
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
