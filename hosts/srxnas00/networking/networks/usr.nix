{
  systemd.network = {
    netdevs = {
      vlan_usr = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan_usr";
        };
        vlanConfig.Id = 300;
      };

      br_usr = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br_usr";
        };
      };
    };

    networks = {
      bond0.vlan = [ "vlan_usr" ];

      vlan_usr = {
        matchConfig.Name = "vlan_usr";
        networkConfig.Bridge = "br_usr";
        linkConfig.RequiredForOnline = "enslaved";
      };

      br_usr = {
        matchConfig.Name = "br_usr";
        address = [
          "10.50.0.10/23"
          "fd42:fab:2381:500::10/119"
        ];
        routes = [
          { routeConfig.Gateway = "10.50.0.1"; }
          { routeConfig.Gateway = "fe80::1"; }
        ];
        bridgeConfig = { };
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
