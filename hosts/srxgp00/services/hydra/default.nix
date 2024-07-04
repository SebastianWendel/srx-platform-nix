{ lib, pkgs, config, ... }:
let
  host = {
    hydra = "build.nix.srx.digital";
    cache = "cache.nix.srx.digital";
  };
  job_name = "hydra";
  listenHost = "127.0.0.1";
  s3 = {
    host = "s3.srx.digital";
    bucket = "nix-cache";
    region = "eu-central-1";
    scheme = "https";
  };
  metrics = {
    notify = 9161;
    runner = 9162;
  };
in
{
  age.secrets = {
    hydra-env-secret = {
      file = ./secrets.age;
      group = "hydra";
      mode = "0440";
    };
    hydra-private-key = {
      file = ./private-key.age;
      group = "hydra";
      mode = "0440";
    };
  };

  nix = {
    settings = {
      allowed-uris = [
        "github:"
        "gitlab:"
        "https:"
        "git+https:"
        "git+ssh:"
      ];

      trusted-users = [
        "hydra"
        "hydra-evaluator"
        "hydra-queue-runner"
      ];

      allowed-users = [ "hydra-www" ];
      builders-use-substitutes = true;
      secret-key-files = config.age.secrets.hydra-private-key.path;
    };

    buildMachines = [{
      hostName = "localhost";
      sshUser = "hydra-queue-runner";
      systems = [ "x86_64-linux" "aarch64-linux" ];
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
      maxJobs = 8;
    }];
  };

  systemd.services = {
    hydra-server.path = [ pkgs.msmtp ];
    hydra-queue-runner = {
      path = [ pkgs.msmtp ];
      serviceConfig = {
        EnvironmentFile = config.age.secrets.hydra-env-secret.path;
        LimitNOFILE = 65535;
      };
      restartIfChanged = false;
      wantedBy = lib.mkForce [ ];
      requires = lib.mkForce [ ];
    };
    hydra-notify = {
      path = [ pkgs.msmtp ];
      serviceConfig.EnvironmentFile = config.age.secrets.hydra-env-secret.path;
    };
    hydra-evaluator.serviceConfig.EnvironmentFile = config.age.secrets.hydra-env-secret.path;
  };

  services = {
    hydra = {
      enable = true;
      inherit listenHost;
      hydraURL = "https://${host.hydra}";
      logo = pkgs.fetchurl {
        url = "https://code.srx.digital/avatars/af0c14fc152841cfdcbe4ab098278c35d6fab7cfb236a9744c19cd299d45ef5d";
        hash = "sha256-mEpreI0azCqPMA3jGT4V5FJN0e94nFTMAIzP+HfufCQ=";
      };
      notificationSender = "no-reply@srx.digital";
      smtpHost = "mail.srx.digital";
      useSubstitutes = true;
      extraConfig = ''
        email_notification = 1

        max_db_connections = 350
        max_concurrent_evals = 1

        <git-input>
          timeout = ${toString (60 * 60)}
        </git-input>

        <Plugin::Session>
          cache_size = 32m
        </Plugin::Session>

        <hydra_notify>
          <prometheus>
            listen_address = ${config.services.hydra.listenHost}
            port = ${toString metrics.notify}
          </prometheus>
        </hydra_notify>

        queue_runner_metrics_address = ${config.services.hydra.listenHost}:${toString metrics.runner}

        store_uri = s3://${s3.bucket}?endpoint=${s3.host}&region=${s3.region}&secret-key=${config.age.secrets.hydra-private-key.path}&write-nar-listing=1&ls-compression=br&log-compression=br
        binary_cache_public_uri = https://${host.cache}

        upload_logs_to_binary_cache = true
        compress_build_logs = false

        max_output_size = ${toString (10 * 1024 * 1024 * 1024)}
      '';
    };

    nginx.virtualHosts = {
      "${host.hydra}" = {
        forceSSL = true;
        enableACME = true;
        locations = {
          "/".proxyPass = "http://${config.services.hydra.listenHost}:${toString config.services.hydra.port}";
          "/static/".alias = "${config.services.hydra.package}/libexec/hydra/root/static/";
        };
      };

      "${host.cache}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://localhost${config.services.minio.listenAddress}/${s3.bucket}/";
          extraConfig = ''
            proxy_set_header Connection "";
            chunked_transfer_encoding off;
          '';
        };
        extraConfig = ''
          ignore_invalid_headers off;
          client_max_body_size 0;
          proxy_buffering off;
        '';
      };
    };

    postgresqlBackup.databases = lib.optionals config.services.hydra.enable [ job_name ];

    prometheus.scrapeConfigs = [
      {
        job_name = "hydra";
        metrics_path = "/prometheus";
        scheme = "https";
        static_configs = [{ targets = [ "${host.hydra}:443" ]; }];
      }
      {
        job_name = "hydra_notify";
        metrics_path = "/metrics";
        scheme = "http";
        static_configs = [
          { targets = [ "${config.services.hydra.listenHost}:${toString metrics.notify}" ]; }
        ];
      }
      {
        job_name = "hydra_queue_runner";
        metrics_path = "/metrics";
        scheme = "http";
        static_configs = [
          { targets = [ "${config.services.hydra.listenHost}:${toString metrics.runner}" ]; }
        ];
      }
      {
        job_name = "hydra-webserver";
        metrics_path = "/metrics";
        scheme = "http";
        static_configs = [{
          targets = [ "${config.services.hydra.listenHost}:${toString config.services.hydra.port}" ];
        }];
      }
    ];

    telegraf.extraConfig.inputs = {
      x509_cert = [{
        sources = [ "https://${host.hydra}:443" ];
        tags.host = host.hydra;
        interval = "10m";
      }];

      http_response = [{
        urls = [ "https://${host.hydra}" ];
        tags.host = host.hydra;
        interval = "10m";
      }];
    };
  };

  users.users.hydra-queue-runner.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPtiFwECxheHv30ELg61uS6Ixc0QAIdG26BGl5f2+RsJ hydra-queue-runner@srxgp00"
  ];
}
