{ config, ... }:
{
  age.secrets.vpnSrx = {
    file = ../../vpn_srx.age;
    owner = "systemd-network";
  };

  systemd.network = {
    netdevs."50-vpn_srx" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "vpn_srx";
        MTUBytes = "1300";
      };
      wireguardConfig = {
        PrivateKeyFile = config.age.secrets.vpnSrx.path;
        ListenPort = 51820;
      };
      wireguardPeers = [
        {
          wireguardPeerConfig = {
            # srxnas01.vpn.srx.dev
            PublicKey = "vXNyMPTm2Gwmu5xwR4NA6neuH849YdTtIzQ03L1IZVY=";
            AllowedIPs = [ "10.80.0.2/32" "10.50.0.0/23" ];
          };
        }
        {
          wireguardPeerConfig = {
            # srxws00.vpn.srx.dev
            PublicKey = "vi/DohCorqMv8lR8TwI27YM6F9uRggD9T2E5PdbiCBs=";
            AllowedIPs = [ "10.80.0.3/32" ];
          };
        }
        {
          wireguardPeerConfig = {
            # srxmc00.vpn.srx.dev
            PublicKey = "bxA6bVjEn6UmOizdmujDPe2DxU2iSVJus+FQPdlKJGI=";
            AllowedIPs = [ "10.80.0.14/32" ];
          };
        }
        {
          wireguardPeerConfig = {
            # srxnas00.vpn.srx.dev
            PublicKey = "kiEzfTU5pWSy7r/RuRXE8/4rnvctebVq1mZ+8BfLzQk=";
            AllowedIPs = [ "10.80.0.4/32" "192.168.178.0/24" ];
          };
        }
        {
          wireguardPeerConfig = {
            # srxgp01.vpn.srx.dev
            PublicKey = "FFErzX2/KEv/k5FNrp9w7j8+JKz5P+D8WqunoksHxg8=";
            AllowedIPs = [ "10.80.0.5/32" ];
          };
        }
        {
          wireguardPeerConfig = {
            # srxgp02.vpn.srx.dev
            PublicKey = "WYJaYVzyJTbrOKz3dW8PKl3c6vRcJQx0/AE6LGWRfl4=";
            AllowedIPs = [ "10.80.0.6/32" ];
          };
        }
        {
          wireguardPeerConfig = {
            # srxk8s00.vpn.srx.dev
            PublicKey = "ukZbSy6XDELBg2jGjnwINr73G7OyT0tmAkVuTKs7zjc=";
            AllowedIPs = [ "10.80.0.7/32" ];
          };
        }
        {
          wireguardPeerConfig = {
            # srxws01.vpn.srx.dev
            PublicKey = "UszZ79FXBcXllXmRC9/LKw+Qc+fNHvZnCA9+DYdXKx0=";
            AllowedIPs = [ "10.80.0.8/32" ];
          };
        }
        {
          wireguardPeerConfig = {
            # srxtab00.vpn.srx.dev
            PublicKey = "pYYc6p3KNHMtTPXojK8urO3MURnaG9/wyEg7hOUDUGM=";
            AllowedIPs = [ "10.80.0.9/32" ];
          };
        }
        {
          wireguardPeerConfig = {
            # srxfdm00.vpn.srx.dev
            PublicKey = "eJ6OhRhTwSyxdT466SQbrjAIMFSZ8C1yVFMEeDxHxSw=";
            AllowedIPs = [ "10.80.0.12/32" ];
          };
        }
        {
          wireguardPeerConfig = {
            # srxnb00.srx.digital
            PublicKey = "3nWyVTUqkH/6b45FmRV7DKy13wp9g6vgxqL28GFZpFA=";
            AllowedIPs = [ "10.80.0.100/32" ];
          };
        }
        {
          wireguardPeerConfig = {
            # copepod.curious.bio
            PublicKey = "WTAG/4iEQO1S5H6uwQB2z+r9q8nMkVILILrSnqu23zc=";
            AllowedIPs = [ "10.80.0.10/32" ];
          };
        }
        {
          wireguardPeerConfig = {
            # diatome.curious.bio
            PublicKey = "lyz3nEnjCMi2fX0HAstSUbfOkXYn6HNgkYz0I6w3r3w=";
            AllowedIPs = [ "10.80.0.50/32" "10.10.0.0/24" ];
          };
        }
        {
          wireguardPeerConfig = {
            # opd00.octopod.de
            PublicKey = "D3/wnVy1BUgNvSwkhPMoaZIbxycUpjVHByEmlznZj2U=";
            AllowedIPs = [ "10.80.0.66/32" ];
          };
        }
      ];
    };

    networks."vpn_srx" = {
      matchConfig.Name = "vpn_srx";
      address = [ "10.80.0.1/24" ];
      routes = [
        {
          routeConfig = {
            Gateway = "10.80.0.2";
            Destination = "10.50.0.0/23";
          };
        }
        {
          routeConfig = {
            Gateway = "10.80.0.4";
            Destination = "192.168.178.0/24";
          };
        }
        {
          routeConfig = {
            Gateway = "10.80.0.50";
            Destination = "10.10.0.0/24";
          };
        }
      ];

      networkConfig = {
        IPMasquerade = "ipv4";
        IPForward = true;
      };
    };
  };

  networking = {
    nat = {
      enable = true;
      externalInterface = "enp9s0";
      internalInterfaces = [ "vpn_srx" ];
    };

    firewall = {
      allowedUDPPorts = [ 51820 ];
      trustedInterfaces = [ "vpn_srx" ];
    };
  };
}
