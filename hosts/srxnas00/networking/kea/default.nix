{ lib, config, ... }:
let
  dns = {
    host = "srx.dev";
    servers = "dns.vpn.${dns.host}";
    zone = "op.hq.hh.${dns.host}";
  };
in
{
  networking.firewall.interfaces = {
    br_usr = {
      allowedUDPPorts = [ 67 ];
      allowedTCPPorts = [ 67 ];
    };
  };

  services.kea = {
    ctrl-agent = {
      enable = true;
      settings = {
        control-sockets = {
          dhcp4 = {
            socket-name = "/run/kea/kea-dhcp4.socket";
            socket-type = "unix";
          };
          dhcp6 = {
            socket-name = "/run/kea/kea-dhcp6.socket";
            socket-type = "unix";
          };
        };
      };
    };

    # dhcp-ddns = {
    #   # https://kea.readthedocs.io/en/kea-2.2.0/arm/ddns.html#adding-forward-dns-servers
    #   enable = true;
    #   settings = {
    #     forward-ddns = {
    #       ddns-hosts = [
    #         {
    #           name = "${dns.host}.";
    #           key-name = "update";
    #           dns-servers = [
    #             {
    #               ip-address = inputs.dns.servers;
    #               port = 53;
    #             }
    #           ];
    #         }
    #       ];
    #     };
    #   };
    # };

    dhcp4 = {
      enable = true;
      settings = {
        interfaces-config.interfaces = [ "br_usr" ];

        control-socket = {
          socket-name = "/run/kea/kea-dhcp4.socket";
          socket-type = "unix";
        };

        lease-database = {
          name = "/var/lib/kea/dhcp4.leases";
          persist = true;
          type = "memfile";
        };

        rebind-timer = 2000;
        renew-timer = 1000;
        valid-lifetime = 4000;

        match-client-id = false;

        client-classes = [
          {
            name = "iPXE";
            test = "substring(option[77].hex, 0, 4) == 'iPXE'";
            boot-file-name = "http://netboot.srx.digital/boot.php";
          }
          {
            name = "UEFI-32-7";
            test = "substring(option[60].hex,0,20) == 'PXEClient:Arch:00007'";
            boot-file-name = "ipxe.efi";
          }
          {
            name = "UEFI-32-8";
            test = "substring(option[60].hex,0,20) == 'PXEClient:Arch:00008'";
            boot-file-name = "ipxe.efi";
          }
          {
            name = "UEFI-32-9";
            test = "substring(option[60].hex,0,20) == 'PXEClient:Arch:00009'";
            boot-file-name = "ipxe.efi";
          }
          {
            name = "Legacy";
            test = "substring(option[60].hex,0,20) == 'PXEClient:Arch:00000'";
            boot-file-name = "undionly.kpxe";
          }
        ];

        subnet4 = [
          {
            interface = "br_usr";
            subnet = "10.50.0.0/23";
            pools = [{ pool = "10.50.0.100 - 10.50.0.250"; }];
            option-data = [
              {
                name = "routers";
                data = "10.50.0.1";
              }
              {
                name = "domain-name";
                data = dns.host;
              }
              {
                name = "domain-name-servers";
                # data = "10.50.0.10";
                data = "10.50.0.1";
              }
              {
                name = "domain-search";
                data = dns.zone;
              }
            ];
            reservations = [
              {
                hostname = "srxws00.${dns.zone}";
                ip-address = "10.50.0.200";
                hw-address = "f4:a8:0d:07:f4:5c";
                next-server = "10.50.0.10";
              }
              {
                hostname = "srxws00.${dns.zone}";
                ip-address = "10.50.0.201";
                hw-address = "c8:94:02:b9:a8:83";
                next-server = "10.50.0.10";
              }
              {
                hostname = "vm-pxe-test1.${dns.zone}";
                ip-address = "10.50.0.250";
                hw-address = "52:54:00:21:33:86";
                next-server = "10.50.0.10";
              }
              {
                hostname = "vm-pxe-test2.${dns.zone}";
                ip-address = "10.50.0.251";
                hw-address = "52:54:00:db:34:7f";
                next-server = "10.50.0.10";
              }
              {
                hostname = "nixos-karos.${dns.zone}";
                ip-address = "10.50.0.123";
                hw-address = "b4:a9:fc:7d:d8:dc";
                next-server = "10.50.0.10";
              }
            ];
          }
        ];

        # dhcp-ddns.enable-updates = true;
        # ddns-send-updates = true;
        # ddns-qualifying-suffix = "${dns.zone}.";
      };
    };

    dhcp6 = {
      enable = true;
      settings = {
        interfaces-config.interfaces = [ "br_usr" ];

        control-socket = {
          socket-name = "/run/kea/kea-dhcp6.socket";
          socket-type = "unix";
        };

        lease-database = {
          name = "/var/lib/kea/dhcp6.leases";
          persist = true;
          type = "memfile";
        };

        preferred-lifetime = 3000;
        rebind-timer = 2000;
        renew-timer = 1000;
        valid-lifetime = 4000;

        subnet6 = [
          {
            interface = "br_usr";
            subnet = "fd42:fab:2381:500::/119";
            pools = [{ pool = "fd42:fab:2381:500::50-fd42:fab:2381:500::1ff"; }];
            option-data = [
              {
                name = "dns-servers";
                # data = "fd42:fab:2381:500::10";
                data = "fd42:fab:2381:500::1";
              }
            ];
          }
        ];
        # dhcp-ddns.enable-updates = true;
        # ddns-send-updates = true;
        # ddns-qualifying-suffix = "${dns.zone}.";
      };
    };
  };

  services.prometheus.exporters.kea = {
    enable = lib.mkIf config.services.kea.dhcp4.enable or config.services.kea.dhcp6.enable true;
    controlSocketPaths =
      lib.optionals config.services.kea.dhcp4.enable [ "/run/kea/kea-dhcp4.socket" ]
      ++ lib.optionals config.services.kea.dhcp6.enable [ "/run/kea/kea-dhcp6.socket" ];
  };

  systemd.services.kea-ctrl-agent = {
    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];
  };
}
