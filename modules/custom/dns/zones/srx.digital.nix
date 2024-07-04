{ inputs, config, ... }:
with config.srx.service.dns;
with inputs.dns.lib.combinators;
{
  srx.service.dns.zones."srx.digital" = {
    inherit (defaults) SOA NS TTL MX TXT A AAAA;

    DKIM = [{
      selector = "mail";
      s = [ "email" ];
      p = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDbg881GUU/m6SGOkSbg4/USEP0TnN7xPqrv1tcALo1wnNRmUjBBIrQueidF0vwlEQr41iuuDH28ggKuSSUmlfxFVWvaYrgN2hdd54xCshfW47kUwsH+J8VzrLTAUU4p8PP2EMRVvF2cKPce4tdBWHjbw4YzfYlyTTo3vBS/aLE1QIDAQAB";
    }];

    DMARC = [{
      p = "quarantine";
      sp = "reject";
      rua = [ "mailto:dmarc@srx.digital" ];
      ruf = [ "mailto:dmarc@srx.digital" ];
    }];

    SRV = [
      { service = "https"; proto = "tcp"; port = 443; target = "autoconfig"; }
      { service = "caldavs"; proto = "tcp"; port = 443; target = "cloud"; }
      { service = "carddavs"; proto = "tcp"; port = 443; target = "cloud"; }
      { service = "submissions"; proto = "tcp"; port = 465; target = "mail"; }
      { service = "imaps"; proto = "tcp"; port = 993; target = "mail"; }
    ];

    subdomains = rec {
      srxgp00 = host "65.108.77.254" "2a01:4f9:6b:2573::1";
      srxgp01 = host "152.53.17.250" "2a0a:4cc0:1:131a::1";
      srxgp02 = host "212.132.77.48" "2a02:247a:275:9300::1";
      srxk8s00 = host "78.46.220.70" "2a01:4f8:1c0c:5214::1";

      whoami = delegateTo [ "ns1" "ns2" "ns3" ];
      whoami6 = delegateTo [ "ns1" "ns2" "ns3" ];

      dns = srxgp00;
      ns1 = srxgp00;
      ns2 = srxgp01;
      ns3 = srxgp02;

      mail = srxgp00;
      autoconfig = srxgp00;

      ldap = srxgp00;
      support = srxgp00;
      checkip = srxgp00;
      netboot = srxgp00;
      tsdb = srxgp00;
      id = srxgp00;
      vault = srxgp00;
      cloud = srxgp00;
      code = srxgp00;
      "live.code" = srxgp00;
      pad = srxgp00;
      analytics = srxgp00;
      home = srxgp00;
      auth = srxgp00;
      media = srxgp00;
      office = srxgp00;
      paper = srxgp00;
      meet = srxgp00;
      survey = srxgp00;
      metrics = srxgp00;
      logs = srxgp00;
      turn = srxgp00;
      status = srxgp00;
      "push.status" = srxgp00;
      alerts = srxgp00;
      push = srxgp00;
      s3 = srxgp00;
      "admin.s3" = srxgp00;

      nix.subdomains = {
        cache = srxgp00;
        build = srxgp00;
        hydra = srxgp00;
      };

      matrix = {
        CNAME = [ "srx.digital." ];
        subdomains = {
          chat = srxgp00;
          admin = srxgp00;
        };
      };

      "hq.op.hh".subdomains = rec {
        srxfw01 = host "10.50.0.1" null;
        srxsw01 = host "10.50.0.3" null;
        srxap01 = host "10.50.0.4" null;
        srxnas01 = host "10.50.0.10" null;
        netboot = srxnas01;
        nfs = srxnas01;
      };

      "hq.op.l".subdomains = {
        srxnas00 = host "192.168.178.71" null;
      };
    };
  };
}
