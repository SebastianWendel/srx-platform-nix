{ inputs, config, ... }:
with config.srx.service.dns;
with inputs.dns.lib.combinators;
{
  srx.service.dns.zones."srx.dev" = {
    inherit (defaults) SOA NS TTL MX TXT DMARC A AAAA;

    DKIM = [{
      selector = "mail";
      s = [ "email" ];
      p = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDMbarSAE2a5vfPEc/JeXtpZqD7xW2BBUmcNNuSyyHZ7IUmY52OjGFxIiSaj+Q0f8SJVtCq45fkvckreXj9yzx/h3WimDkFlPzElBiuuapulPBj1BSI3eM7O+FCU/4MdI+zEL1QMz2Lcq5o+xW3IwxEEWAygQyP3Z/ac/Rzt65NaQIDAQAB";
    }];

    subdomains = rec {
      srxgp00 = host "65.108.77.254" "2a01:4f9:6b:2573::1";
      srxgp01 = host "152.53.17.250" "2a0a:4cc0:1:131a::1";
      srxgp02 = host "212.132.77.48" "2a02:247a:275:9300::1";

      ns1 = srxgp00;
      ns2 = srxgp01;
      ns3 = srxgp02;

      vpn = delegateTo [
        "ns1"
        "ns2"
        "ns3"
      ];
    };
  };
}
