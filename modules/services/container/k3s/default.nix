{ lib, pkgs, config, inputs, ... }:
let
  inherit (inputs) kubenix;
  k3s-reset-node = pkgs.writeShellScriptBin "k3s-reset-node" ''
    read -p "Are you sure? This will purge all k3s data: " -n 1 -r; echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      set +e
      systemctl stop containerd.service k3s.service 2>/dev/null
      systemctl kill containerd.service k3s.service 2>/dev/null
      find /sys/fs/cgroup/systemd/system.slice/containerd.service* /sys/fs/cgroup/kubepods* -name cgroup.procs -print0 | xargs -0 -r cat | xargs -r kill -9 2>/dev/null
      mount | awk '/\/var\/lib\/kubelet|\/run\/netns|\/run\/containerd/ {print $3}' | xargs -r umount 2>/dev/null
      for ID in $(zfs list -r rpool/data/containerd | grep rpool/data/containerd/ | awk '{print $1}'); do zfs destroy -R $ID; done 2>/dev/null
      rm -rf /run/containerd /etc/rancher /var/lib/cni /var/lib/containerd /var/lib/kubelet /var/lib/rancher 2>/dev/null
      set -e
      systemctl start containerd.service k3s.service
    fi
  '';
in
{
  age.secrets = {
    k8s_cluster_token.file = ./k8s_cluster_token.age;
    k8s_environment.file = ./k8s_environment.age;
    k8s_dns_update_rfc2136.file = ./k8s_dns_update_rfc2136.age;
    k8s_traefik_dashboard.file = ./k8s_traefik_dashboard.age;
  };

  environment = {
    systemPackages = with pkgs; [
      k3s
      k3s-reset-node
    ];

    shellAliases = {
      k = "${pkgs.k3s}/bin/k3s kubectl";
      kubectl = "${pkgs.k3s}/bin/k3s kubectl";
    };

    etc."kubenix.yaml".source =
      (kubenix.evalModules.${pkgs.hostPlatform.system} {
        module =
          { kubenix, ... }:
          {
            imports = [ kubenix.modules.k8s ];
            kubernetes = {
              version = "1.26";
              resources = {
                namespaces = {
                  "traefik" = { };
                  "cert-manager" = { };
                  "external-dns" = { };
                };
                secrets = {
                  traefik-dashboard-auth-secret = {
                    metadata.namespace = "traefik";
                    data.users = "ref+file://${config.age.secrets.k8s_traefik_dashboard.path}";
                  };
                  dns-rfc2136-key-cert-manager = {
                    metadata.namespace = "cert-manager";
                    stringData.password = "ref+file://${config.age.secrets.k8s_dns_update_rfc2136.path}";
                  };
                  dns-rfc2136-key-external-dns = {
                    metadata.namespace = "external-dns";
                    stringData.password = "ref+file://${config.age.secrets.k8s_dns_update_rfc2136.path}";
                  };
                };
              };
            };
          };
      }).config.kubernetes.resultYAML;
  };

  virtualisation.containerd = {
    enable = lib.mkIf config.services.k3s.enable true;
    settings =
      let
        fullCNIPlugins = pkgs.buildEnv {
          name = "full-cni";
          paths = with pkgs; [
            cni-plugins
            cni-plugin-flannel
          ];
        };
      in
      {
        plugins."io.containerd.grpc.v1.cri".cni = {
          bin_dir = "${fullCNIPlugins}/bin";
          conf_dir = "/var/lib/rancher/k3s/agent/etc/cni/net.d/";
        };
      };
  };

  services.k3s = {
    package = pkgs.k3s_1_29;
    clusterInit = lib.mkIf (config.services.k3s.role == "server") true;
    tokenFile = config.age.secrets.k8s_cluster_token.path;
    environmentFile = config.age.secrets.k8s_environment.path;
  };

  systemd.services.k3s.path = with pkgs; [
    openiscsi
    nfs-utils
    ipset
  ];

  system.activationScripts.kubenix.text = ''
    cat /etc/kubenix.yaml | ${pkgs.vals}/bin/vals eval > /var/lib/rancher/k3s/server/manifests/kubenix.yaml
  '';

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 2500000;
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [
      80
      443
    ];
  };
}
