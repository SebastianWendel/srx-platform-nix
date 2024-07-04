{ config, ... }:
{
  age.secrets = {
    vpnSrx = {
      file = ../vpn_srx.age;
      owner = "systemd-network";
    };
    vpnCcl = {
      file = ../vpn_ccl.age;
      owner = "systemd-network";
    };
  };

  systemd.network = {
    netdevs = {
      "50-vpn_srx" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "vpn_srx";
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets.vpnSrx.path;
          ListenPort = 51820;
        };
        wireguardPeers = [{
          wireguardPeerConfig = {
            PublicKey = "MPvns6jFwZPJvzZtxEDIMSIBBBtBQKBWQ8us3Wgj0mc=";
            AllowedIPs = [ "10.80.0.0/24" ];
            Endpoint = "65.108.77.254:51820";
          };
        }];
      };
      "51-vpn_ccl" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "vpn_ccl";
          MTUBytes = "1300";
        };
        wireguardConfig = {
          PrivateKeyFile = config.age.secrets.vpnCcl.path;
          ListenPort = 51821;
        };
        wireguardPeers = [{
          wireguardPeerConfig = {
            PublicKey = "0AJ9FTSIPIM1eQaxtCdLMZYDyHfdJBKRwlftMSFRWB8=";
            AllowedIPs = [ "10.80.1.0/24" ];
            Endpoint = "116.202.240.209:51820";
          };
        }];
      };
    };

    networks = {
      "vpn_srx" = {
        matchConfig.Name = "vpn_srx";
        address = [ "10.80.0.100/24" ];
      };
      "vpn_ccl" = {
        matchConfig.Name = "vpn_ccl";
        address = [ "10.80.1.100/24" ];
      };
    };
  };

  networking.firewall.trustedInterfaces = [ "vpn_srx" ];
}
