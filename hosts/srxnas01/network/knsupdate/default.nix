{ config, ... }:
{
  age.secrets.knsupdate = {
    file = ../../dns_update.age;
    owner = config.srx.service.knsupdate.user;
  };

  srx.service.knsupdate = {
    enable = true;
    zone = "srx.digital";
    server = "dns.vpn.srx.dev";
    ttl = 120;
    interval = "*:0/1";
    keyFile = config.age.secrets.knsupdate.path;
  };
}
