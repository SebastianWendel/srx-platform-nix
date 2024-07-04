{ self, lib, ... }:
{
  imports = [
    self.nixosModules.roles-server
    self.nixosModules.filesystems-zfs
    self.nixosModules.services-security-tang
    self.nixosModules.services-netboot
    self.nixosModules.services-monitoring-loki
    self.nixosModules.custom-dns-knot

    ./hardware.nix
    ./storage.nix
    ./services/wireguard
    ./services/nginx
    ./services/oauth2-proxy
    # ./services/openldap
    ./services/mysql
    ./services/influxdb
    ./services/postgresql
    ./services/minio
    ./services/restic
    ./services/grafana
    ./services/prometheus
    ./services/keycloak
    ./services/mailserver
    ./services/coturn
    ./services/dendrite
    ./services/hydra
    ./services/plausible
    ./services/forgejo
    ./services/vaultwarden
    ./services/hedgedoc
    ./services/nextcloud
    ./services/paperless
    ./services/jellyfin
  ];

  system.stateVersion = "24.05";

  networking = {
    hostName = "srxgp00";
    domain = "srx.digital";
    hostId = "8556b001";
  };

  systemd.network.networks."10-uplink".networkConfig.Address = "2a01:4f9:6b:2573::1/64";

  services.knot.settings.server = {
    identity = "ns1.srx.dev";
    listen = lib.mkForce [
      "10.80.0.1@53"
      "65.108.77.254@53"
      "2a01:4f9:6b:2573::1@53"
    ];
  };
}
