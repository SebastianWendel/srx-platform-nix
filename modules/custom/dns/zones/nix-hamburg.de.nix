{ config, ... }:
with config.srx.service.dns;
{
  srx.service.dns.zones."nix-hamburg.de" = {
    inherit (defaults) SOA NS TTL MX TXT DMARC A AAAA;

    DKIM = [{
      selector = "mail";
      s = [ "email" ];
      p = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDIkR9v+74PC2RBXtHX7hyTIbQCbysHIwpcTg11ZmY3hl+Z3eKAHJqPHwczLk5O6QfhcoekxrvbM3PnaZBlR76In8Pe4QC8wVK8R171pOL31mqw3XS32yc9MUuoqvx9Q13uFgQwdQpSzqRSPNguNIdgF6cNkIaYP5S+AUE7CFCXjQIDAQAB";
    }];
  };
}
