{ config, ... }:
let
  domains = {
    tld = "srx.digital";
    mail = "mail.${domains.tld}";
    web = "autoconfig.${domains.tld}";
  };
in
{
  services.go-autoconfig = {
    enable = true;
    settings = {
      service_addr = "127.0.0.1:1327";
      domain = "${domains.tld}";
      imap = {
        server = "${domains.mail}";
        port = 993;
      };
      smtp = {
        server = "${domains.mail}";
        port = 465;
      };
    };
  };

  services.nginx.virtualHosts."${domains.web}" = {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "http://${config.services.go-autoconfig.settings.service_addr}";
  };
}
