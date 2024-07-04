{ config, ... }:
let
  Name = "vpn_mvd";
  Description = "EAobLeO0BWJWUQ0JIWFTIld3PjCSC2Je0iY2hzaW/BU=";
  MTUBytes = "1300";
  ListenPort = 51821;
  FirewallMark = 42;
  Table = 51820;
in
{
  age.secrets.vpnMvd = {
    file = ../../vpn_mvd.age;
    owner = "systemd-network";
  };

  # networking.wg-quick.interfaces.vpn_mvd = {
  #   address = ["10.65.243.251/32" "fc00:bbbb:bbbb:bb01::2:f3fa/128"];
  #   privateKeyFile = config.age.secrets.vpnMvd.path;
  #   peers = [
  #     {
  #       allowedIPs = ["0.0.0.0/0" "::0/0"];
  #       publicKey = "UrQiI9ISdPPzd4ARw1NHOPKKvKvxUhjwRjaI0JpJFgM=";
  #       endpoint = "193.32.249.66:51820";
  #     }
  #   ];
  # };

  # networking.wireguard.interfaces.wg0 = {
  #   preSetup = ''
  #     ip netns add ${socketNamespace}
  #   '';
  #   inherit socketNamespace;
  # };

  boot.kernel.sysctl."net.ipv4.conf.all.src_valid_mark" = 1;

  systemd.network = {
    netdevs."${Name}" = {
      netdevConfig = {
        Kind = "wireguard";
        inherit Name Description MTUBytes;
      };

      wireguardConfig = {
        PrivateKeyFile = config.age.secrets.vpnMvd.path;
        inherit ListenPort FirewallMark;
      };

      wireguardPeers = [
        {
          wireguardPeerConfig = {
            Endpoint = "193.32.249.66:51820";
            PublicKey = "UrQiI9ISdPPzd4ARw1NHOPKKvKvxUhjwRjaI0JpJFgM=";
            AllowedIPs = [
              "0.0.0.0/0"
              "::0/0"
            ];
            PersistentKeepalive = 15;
          };
        }
      ];
    };

    networks."${Name}" = {
      matchConfig = {
        inherit Name;
      };
      address = [
        "10.65.243.251/32"
        "fc00:bbbb:bbbb:bb01::2:f3fa/128"
      ];
      networkConfig = {
        DNS = "10.64.0.1";
        DNSDefaultRoute = true;
        inherit Description;
      };
      linkConfig = {
        # ActivationPolicy = "up";
        ActivationPolicy = "manual";
        inherit MTUBytes;
      };
      routes = [
        {
          routeConfig = {
            Destination = "0.0.0.0/0";
            inherit Table;
            # GatewayOnLink = true;
          };
        }
        {
          routeConfig = {
            Destination = "::/0";
            inherit Table;
            # GatewayOnLink = true;
          };
        }
      ];
      routingPolicyRules = [
        {
          routingPolicyRuleConfig = {
            InvertRule = true;
            inherit FirewallMark;
            inherit Table;
          };
        }
        {
          routingPolicyRuleConfig = {
            SuppressPrefixLength = 0;
            Table = "main";
          };
        }
      ];
    };
  };
}
#
## RESTORE
#
# systemctl stop wireguard-vpn_mvd
# ip route replace default via 10.50.0.1
# unlink /etc/resolv.conf ; echo 'nameserver 1.1.1.1' > /etc/resolv.conf
# ping -c 1 8.8.8.8
# dig google.de
#
## CHECKS
# ip address show vpn_mvd
# ip route show table 51820
# ip route get 65.108.77.254
# ip route get 10.50.0.4
# ip rule show table main | grep suppress_prefixlength
# ip rule show table 51820 | grep fwmark
# sysctl net.ipv4.conf.all.src_valid_mark
# curl -s -4 https://checkip.srx.digital/
# curl -s -6 https://checkip.srx.digital/
# https://www.wireguard.com/netns/
#
# ip route show table 51820
# ip route get 65.108.77.254
# ip route get 10.50.0.4
# ip rule show table main | grep suppress_prefixlength
# ip rule show table 51820 | grep fwmark
# sysctl net.ipv4.conf.all.src_valid_mark
# curl -s -4 https://checkip.srx.digital/
# curl -s -6 https://checkip.srx.digital/
# 17: vpn_mvd: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1420 qdisc noqueue state UNKNOWN group default qlen 1000
#     link/none
#     inet 10.65.243.251/32 scope global vpn_mvd
#        valid_lft forever preferred_lft forever
#     inet6 fc00:bbbb:bbbb:bb01::2:f3fa/128 scope global
#        valid_lft forever preferred_lft forever
# default dev vpn_mvd scope link
# 65.108.77.254 dev vpn_mvd table 51820 src 10.65.243.251 uid 0
#     cache
# 10.50.0.4 dev br_usr src 10.50.0.10 uid 0
#     cache
# 32764:	from all lookup main suppress_prefixlength 0
# 32765:	not from all fwmark 0xca6c lookup 51820
# 32765:	not from all fwmark 0x2a   lookup 51820 proto static
# net.ipv4.conf.all.src_valid_mark = 1
# 193.32.249.133
# 2a03:1b20:3:f011::e003
#
#
# ip link add vpn_mvd type wireguard
# ip link set mtu 1420 up dev vpn_mvd
#
# ip -4 address add 10.65.243.251/32 dev vpn_mvd
# ip -4 route add 0.0.0.0/0 dev vpn_mvd table 51820
# ip -4 rule add not fwmark 51820 table 51820
# ip -4 rule add table main suppress_prefixlength 0
#
# ip -6 address add fc00:bbbb:bbbb:bb01::2:f3fa/128 dev vpn_mvd
# ip -6 route add ::/0 dev vpn_mvd table 51820
# ip -6 rule add not fwmark 51820 table 51820
# ip -6 rule add table main suppress_prefixlength 0
#
# sysctl -q net.ipv4.conf.all.src_valid_mark=1
#
# wg set vpn_mvd fwmark 51820
# wg setconf vpn_mvd /dev/fd/63
