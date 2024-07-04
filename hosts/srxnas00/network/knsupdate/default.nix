{ config, ... }:
{
  age.secrets.knsupdate = {
    file = ../../dns_update.age;
    owner = config.users.users.knsupdate.group;
  };

  srx.service.knsupdate = {
    enable = true;
    server = "dns.vpn.srx.dev";
    ttl = 120;
    ipVersions = [ 4 ];
    interval = "*:0/1";
    keyFile = config.age.secrets.knsupdate.path;
  };
}
