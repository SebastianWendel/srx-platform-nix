{ inputs, config, ... }:
with config.srx.service.dns;
with inputs.dns.lib.combinators;
{
  srx.service.dns.zones."vpn.srx.dev" = {
    inherit (defaults) SOA NS TTL;

    subdomains = rec {
      srxgp00 = host "10.80.0.1" null;
      srxgp01 = host "10.80.0.5" null;
      srxgp02 = host "10.80.0.6" null;

      srxk8s00 = host "10.80.0.7" null;

      srxnb00 = host "10.80.0.100" null;
      srxws00 = host "10.80.0.3" null;
      srxws01 = host "10.80.0.8" null;
      srxtab00 = host "10.80.0.9" null;

      srxnas00 = host "10.80.0.4" null;
      srxnas01 = host "10.80.0.2" null;
      srxfdm00 = host "10.80.0.13" null;
      srxmc00 = host "10.80.0.14" null;

      copepod = host "10.80.0.10" null;
      diatome = host "10.80.0.50" null;
      genome = host "10.80.0.22" null;
      opd00 = host "10.80.0.66" null;

      dns = srxgp00;
      ns1 = srxgp00;
      ns2 = srxgp01;
      ns3 = srxgp02;

      ldap = srxgp00;
      logs = srxgp00;
      metrics = srxgp00;
      mail = srxgp00;
      s3 = srxgp00;
      disco = srxgp00;
      k8s = srxk8s00;
      virt = srxk8s00;
      mqtt = srxgp00;
      vault = srxnas00;
      nfs = srxnas00;

      netboot = srxnas01;
      home = srxnas01;

      nix.subdomains = {
        cache = srxgp00;
        build = srxgp00;
      };
    };
  };
}
