{ lib, pkgs, config, ... }:
let
  host = "s3.srx.digital";
  admin = "admin.s3.srx.digital";
in
{
  age.secrets = {
    minioRootCredentials.file = ./user_admin.age;
    minioPrometheusCredentials.file = ./user_prometheus.age;
  };

  environment.shellAliases.minio-client = "${pkgs.minio-client}/bin/mc";

  services = {
    minio = {
      enable = true;
      region = "eu-central-1";
      listenAddress = ":9900";
      consoleAddress = ":9901";
      rootCredentialsFile = config.age.secrets.minioRootCredentials.path;
    };

    nginx.virtualHosts = {
      "${host}" = {
        forceSSL = true;
        enableACME = true;
        extraConfig = ''
          ignore_invalid_headers off;
          client_max_body_size 0;
          proxy_buffering off;
        '';
        locations."/" = {
          proxyPass = "http://localhost${config.services.minio.listenAddress}";
          extraConfig = ''
            proxy_set_header Connection "";
            chunked_transfer_encoding off;
          '';
        };
      };
      "${admin}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost${config.services.minio.consoleAddress}";
          proxyWebsockets = true;
        };
      };
    };

    prometheus.exporters.minio = {
      enable = true;
      minioBucketStats = true;
      minioAddress = "https://${host}/";
    };
  };

  systemd.services = {
    minio.serviceConfig.Environment = [
      "MINIO_SERVER_URL=https://${host}/"
      "MINIO_BROWSER_REDIRECT=false"
    ];

    prometheus-minio-exporter.serviceConfig = {
      EnvironmentFile = config.age.secrets.minioPrometheusCredentials.path;
      ExecStart = lib.mkForce ''
        ${pkgs.prometheus-minio-exporter}/bin/minio-exporter \
          -web.listen-address ${config.services.prometheus.exporters.minio.listenAddress}:${toString config.services.prometheus.exporters.minio.port} \
          -minio.server ${config.services.prometheus.exporters.minio.minioAddress} \
          -minio.access-key $MINIO_PROMETHEUS_USER \
          -minio.access-secret $MINIO_PROMETHEUS_PASSWORD \
          ${lib.optionalString config.services.prometheus.exporters.minio.minioBucketStats "-minio.bucket-stats"}
      '';
    };
  };

  services.telegraf.extraConfig.inputs = {
    x509_cert = [
      {
        sources = [ "https://${host}:443" ];
        tags.host = host;
        interval = "10m";
      }
      {
        sources = [ "https://${admin}:443" ];
        tags.host = admin;
        interval = "10m";
      }
    ];

    http_response = [
      {
        urls = [ "https://${host}" ];
        tags.host = host;
        interval = "10m";
      }
      {
        urls = [ "https://${admin}" ];
        tags.host = admin;
        interval = "10m";
      }
    ];
  };
}
