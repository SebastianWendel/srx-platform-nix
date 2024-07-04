{
  imports = [
    ./wireguard/srx.nix
    ./wireless.nix
    # ./networks/op.nix
    # ./networks/wan.nix
    # ./networks/usr.nix
    # ./networks/dmz.nix
    # ./networks/gst.nix
    # ./wireguard/mullvad.nix
    # ./dns/knsupdate.nix
    # ./dns/blocky.nix
    # ./kea
  ];

  networking.useNetworkd = true;

  systemd.network = {
    enable = true;
    # netdevs = {
    #   bond0 = {
    #     netdevConfig = {
    #       Kind = "bond";
    #       Name = "bond0";
    #     };
    #     bondConfig = {
    #       Mode = "802.3ad";
    #       LACPTransmitRate = "fast";
    #       TransmitHashPolicy = "layer3+4";
    #       DownDelaySec = 0.2;
    #       UpDelaySec = 0.2;
    #       MIIMonitorSec = 0.1;
    #     };
    #   };
    # };

    networks = {
      enp2s0 = {
        matchConfig.Name = "enp2s0";
        matchConfig.MACAddress = "00:1e:06:45:12:27";
        address = [ "192.168.178.10/24" ];
        routes = [
          { routeConfig.Gateway = "192.168.178.1"; }
          { routeConfig.Gateway = "fe80::1"; }
        ];
        bridgeConfig = { };
        linkConfig.RequiredForOnline = "routable";
      };

      # enp2s0 = {
      #   # matchConfig.MACAddress = "00:1e:06:45:12:27";
      #   # networkConfig.Bond = "bond0";
      #   networkConfig.LinkLocalAddressing = "no";
      # };

      # enp3s0 = {
      #   matchConfig.MACAddress = "00:1e:06:45:12:28";
      #   networkConfig.Bond = "bond0";
      # };

      # bond0 = {
      #   matchConfig.Name = "bond0";
      #   linkConfig.RequiredForOnline = "carrier";
      #   networkConfig.LinkLocalAddressing = "no";
      # };
    };
  };
}
