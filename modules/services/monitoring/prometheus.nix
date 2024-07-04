{ pkgs, lib, config, ... }:
{
  services.prometheus.exporters = {
    systemd.enable = true;
    smartctl.enable = lib.mkIf config.services.smartd.enable true;
    node = {
      enable = true;
      enabledCollectors = [
        "systemd"
        "processes"
        "cgroups"
      ];
    };
    blackbox = {
      enable = true;
      configFile = pkgs.writeText "blackbox-exporter.yaml" (
        builtins.toJSON {
          modules.ssh_banner = {
            prober = "tcp";
            timeout = "10s";
            tcp = {
              preferred_ip_protocol = "ip4";
              query_response = [{
                expect = "^SSH-2.0-";
                send = "SSH-2.0-blackbox-ssh-check";
              }];
            };
          };
        }
      );
    };
  };
}
