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
      wireguardPeers = [{
        wireguardPeerConfig = {
          PublicKey = "MPvns6jFwZPJvzZtxEDIMSIBBBtBQKBWQ8us3Wgj0mc=";
          AllowedIPs = [ "10.80.0.0/24" "192.168.178.0/24" ];
          Endpoint = "65.108.77.254:51820";
        };
      }];
    };

    networks."vpn_srx" = {
      matchConfig.Name = "vpn_srx";
      address = [ "10.80.0.4/24" ];
      networkConfig.IPForward = true;
    };
  };

  networking.firewall.trustedInterfaces = [ "vpn_srx" ];
}
