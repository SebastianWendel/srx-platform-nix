{
  systemd.network = {
    netdevs = {
      vlan_gst = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan_gst";
        };
        vlanConfig.Id = 400;
      };

      br_gst = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br_gst";
        };
      };
    };

    networks = {
      bond0.vlan = [ "vlan_gst" ];

      vlan_gst = {
        matchConfig.Name = "vlan_gst";
        networkConfig.Bridge = "br_gst";
        linkConfig.RequiredForOnline = "enslaved";
      };

      br_gst = {
        matchConfig.Name = "br_gst";
        address = [
          "192.168.52.10/24"
          "fd42:fab:2381:400::10/120"
        ];
        bridgeConfig = { };
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
