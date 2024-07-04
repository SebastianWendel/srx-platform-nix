{ pkgs, ... }:
{
  services.unbound = {
    enable = true;
    settings = {
      remote-control = {
        control-enable = true;
        control-use-cert = false;
      };
      server = {
        num-threads = 4;
        verbosity = 1;
        prefetch = true;
        prefetch-key = true;
        serve-expired = true;
        cache-min-ttl = 60;
        cache-max-ttl = 3600;
        infra-cache-slabs = "8";
        key-cache-slabs = "8";
        msg-cache-slabs = "8";
        rrset-cache-slabs = "8";
        msg-cache-size = "256m";
        rrset-cache-size = "512m";
        interface = [
          "0.0.0.0"
          "'::0'"
        ];
        access-control = builtins.concatLists [
          [
            # localhost
            "::1/128 allow"
            "127.0.0.0/8 allow"
          ]
          [
            # default
            "0.0.0.0/0 deny"
            "::/0 deny"
          ]
        ];
        tls-cert-bundle = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
        unblock-lan-zones = true;
        insecure-lan-zones = true;
        domain-insecure = [
          "d.f.ip6.arpa"
          "ffdd"
        ];
      };
      forward-zone = [
        {
          name = ".";
          forward-tls-upstream = true;
          forward-addr = [
            # Quad9
            "2620:fe::fe@853#dns.quad9.net"
            "9.9.9.9@853#dns.quad9.net"
            "2620:fe::9@853#dns.quad9.net"
            "149.112.112.112@853#dns.quad9.net"
            # Cloudflare DNS
            "2606:4700:4700::1111@853#cloudflare-dns.com"
            "1.1.1.1@853#cloudflare-dns.com"
            "2606:4700:4700::1001@853#cloudflare-dns.com"
            "1.0.0.1@853#cloudflare-dns.com"
          ];
        }
      ];
    };
  };
}
