{ inputs, lib, ... }:
with lib.lists;
with inputs.dns.lib.combinators;
{
  imports = with inputs; [
    srx-nixos-shadow.nixosModules.dns

    ./curious.bio.nix
    ./nix-hamburg.de.nix
    ./sourceindex.de.nix
    ./srx.digital.nix
    ./srx.dev.nix
    ./vpn.srx.dev.nix
  ];

  srx.service.dns = rec {
    defaults = {
      SOA = {
        nameServer = "${last (reverseList defaults.NS)}";
        adminEmail = "1egh0the@srx.digital";
        serial = 2024031918;
        refresh = 6 * 60 * 60;
        retry = 60 * 60;
      };
      NS = [ "ns1.srx.dev." "ns2.srx.dev." "ns3.srx.dev." ];
      TTL = 3 * 60 * 60;
      MX = [ (mx.mx 10 "mail.srx.digital.") ];
      TXT = [ (with spf; strict [ "mx" ]) ];
      DMARC = [{ p = "quarantine"; sp = "reject"; }];
      A = [ "65.108.77.254" ];
      AAAA = [ "2a01:4f9:6b:2573::1" ];
    };

    zones = {
      "srx81.de" = { inherit (defaults) SOA NS TXT; };
      "whoami.srx.digital" = { inherit (defaults) SOA NS A; };
      "whoami6.srx.digital" = { inherit (defaults) SOA NS AAAA; };
      "flowflexure.bio" = { inherit (defaults) SOA NS TXT MX DMARC A AAAA; };
    };
  };
}
