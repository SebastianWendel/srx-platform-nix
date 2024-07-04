{ pkgs, ... }:
let
  host = "mail.srx.digital";
in
{
  services.roundcube = {
    enable = true;
    hostName = "${host}";
    dicts = with pkgs.aspellDicts; [ en fr es de ];
    extraConfig = ''
      $config['imap_host'] = "ssl://${host}";
      $config['smtp_host'] = "ssl://${host}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";
    '';
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
