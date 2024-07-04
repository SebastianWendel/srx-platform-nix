{ self, lib, config, ... }:
{
  imports = [ self.nixosModules.services-container-k3s ];

  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--tls-san=k8s.vpn.srx.dev"
      "--cluster-domain=k8s.vpn.srx.dev"

      "--bind-address=10.80.0.7"
      "--advertise-address=10.80.0.7"
      "--cluster-cidr=10.42.0.0/16,2001:cafe:42::/56"
      "--service-cidr=10.43.0.0/16,2001:cafe:43::/112"
      "--node-external-ip=78.46.220.70,2a01:4f8:1c0c:5214::1"
      # "--node-external-ip=10.80.0.7,78.46.220.70,2a01:4f8:1c0c:5214::1"

      "--container-runtime-endpoint unix:///run/containerd/containerd.sock"
      "--write-kubeconfig-mode 644"

      "--disable traefik"

      "--snapshotter=zfs"
      "--node-label storage.os.srx.digital/fs=zfs"

      "--node-label os.srx.digital/release=${config.system.nixos.release}"
      "--node-label os.srx.digital/codename=${config.system.nixos.codeName}"
      "--node-label os.srx.digital/version=${config.system.nixos.version}"
      "--node-label os.srx.digital/kernel=${config.boot.kernelPackages.kernel.version}"
    ];
  };

  virtualisation.containers.storage.settings.storage = {
    driver = lib.mkForce "zfs";
    graphroot = "/var/lib/containers/storage";
    runroot = "/run/containers/storage";
  };
}
