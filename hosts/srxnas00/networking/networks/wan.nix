{
  systemd.network = {
    netdevs = {
      vlan_wan = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan_wan";
        };
        vlanConfig.Id = 200;
      };
    };

    networks = {
      bond0.vlan = [ "vlan_wan" ];

      vlan_wan = {
        matchConfig.Name = "vlan_wan";
        networkConfig.DHCP = "yes";
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
