{
  systemd.network = {
    netdevs = {
      vlan_op = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan_op";
        };
        vlanConfig.Id = 500;
      };

      br_op = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br_op";
        };
      };
    };

    networks = {
      bond0.vlan = [ "vlan_op" ];

      vlan_op = {
        matchConfig.Name = "vlan_op";
        networkConfig.Bridge = "br_op";
        linkConfig.RequiredForOnline = "enslaved";
      };

      br_op = {
        matchConfig.Name = "br_op";
        address = [
          "10.40.0.10/23"
          "fd42:fab:2381:400::10/120"
        ];
        bridgeConfig = { };
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
