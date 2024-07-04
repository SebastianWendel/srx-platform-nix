{ config, ... }:
{
  services.nfs.server = {
    enable = true;

    statdPort = 4000;
    lockdPort = 4001;
    mountdPort = 4002;

    exports = ''
      /export                                               \
        10.80.0.0/24(ro,fsid=0,no_subtree_check)            \
        10.50.0.0/23(ro,fsid=0,no_subtree_check)            \
        192.168.178.0/24(ro,fsid=0,no_subtree_check)

      /export/public                                        \
        10.80.0.0/24(ro,fsid=0,no_subtree_check)            \
        10.50.0.0/23(ro,nohide,insecure,no_subtree_check)   \
        192.168.178.0/24(ro,nohide,insecure,no_subtree_check)
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [
      111
      2049
      config.services.nfs.server.statdPort
      config.services.nfs.server.lockdPort
      config.services.nfs.server.mountdPort
    ];
    allowedUDPPorts = [
      111
      2049
      config.services.nfs.server.statdPort
      config.services.nfs.server.lockdPort
      config.services.nfs.server.mountdPort
    ];
  };

  fileSystems = {
    "/export/public" = {
      device = "/srv/public";
      options = [
        "bind"
        "X-mount.mkdir"
      ];
    };
  };
}
