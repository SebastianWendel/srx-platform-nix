{
  systemd.network = {
    netdevs = {
      vlan_dmz = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan_dmz";
        };
        vlanConfig.Id = 600;
      };

      br_dmz = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br_dmz";
        };
      };
    };

    networks = {
      bond0.vlan = [ "vlan_dmz" ];

      vlan_dmz = {
        matchConfig.Name = "vlan_dmz";
        networkConfig.Bridge = "br_dmz";
        linkConfig.RequiredForOnline = "enslaved";
      };

      br_dmz = {
        matchConfig.Name = "br_dmz";
        address = [
          "10.60.0.10/23"
          "fd42:fab:2381:600::10/120"
        ];
        bridgeConfig = { };
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
