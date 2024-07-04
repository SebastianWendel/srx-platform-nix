{ inputs, pkgs, config, lib, ... }:
{
  imports = with inputs; [
    srvos.nixosModules.mixins-nginx
  ];

  services = {
    nginx = {
      enable = true;
      package = pkgs.nginxQuic;
      statusPage = true;
      clientMaxBodySize = "4096m";
      commonHttpConfig = ''
        map $scheme $hsts_header {
          https "max-age=31536000; includeSubdomains";
        }

        add_header Strict-Transport-Security $hsts_header;

        proxy_headers_hash_max_size 1024;
        proxy_headers_hash_bucket_size 128;
      '';
    };

    prometheus.exporters.nginx.enable = true;
    telegraf.extraConfig.inputs.nginx.urls = [ "http://localhost/nginx_status" ];
  };

  systemd.services.nginx = {
    requires = lib.optionals config.services.resolved.enable [
      "systemd-resolved.service"
    ];
    after = lib.optionals config.services.resolved.enable [
      "network.target"
      "systemd-resolved.service"
    ];
  };

  networking.firewall.allowedUDPPorts = [ 80 443 ];
}
