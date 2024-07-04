{ pkgs, config, ... }:
let
  name = "dendrite";
  domain_name = "srx.digital";
  server_name = "matrix.${domain_name}";
  admin_domain = "admin.${server_name}";
  chat_domain = "chat.${server_name}";
  bindHost = "localhost";
in
{
  age.secrets = {
    dendriteEnvironment.file = ./environment.age;
    dendritePrivateKey.file = ./private-key.age;
  };

  services = {
    dendrite = {
      enable = true;
      openRegistration = false;
      environmentFile = config.age.secrets.dendriteEnvironment.path;
      settings = {
        global = {
          server_name = domain_name;
          private_key = "$CREDENTIALS_DIRECTORY/private_key";

          database = {
            connection_string = "postgres:///${name}?host=/run/postgresql";
            max_open_conns = 90;
            max_idle_conns = 5;
            conn_max_lifetime = -1;
          };

          logging = [{
            type = "std";
            level = "info";
          }];

          metrics.enabled = true;

          trusted_third_party_id_servers = [
            "matrix.org"
            "vector.im"
            "nixos.org"
          ];

          dns_cache = {
            enabled = true;
            cache_size = 4096;
            cache_lifetime = "600s";
          };
        };

        media_api.dynamic_thumbnails = true;
        mscs.mscs = [ "msc2836" ];

        client_api = {
          registration_disabled = true;
          rate_limiting.enabled = false;
          registration_shared_secret = "$REGISTRATION_SHARED_SECRET";
        };

        sync_api = {
          search.enable = true;
          real_ip_header = "X-Real-IP";
        };

        federation_api = {
          key_perspectives = [{
            server_name = "matrix.org";
            keys = [
              {
                key_id = "ed25519:auto";
                public_key = "Noi6WqcDj0QmPxCNQqgezwTlBKrfqehY1u2FyWP9uYw";
              }
              {
                key_id = "ed25519:a_RXGa";
                public_key = "l8Hft5qXKn1vfHrg3p4+W8gELQVo8N13JkluMfmn2sQ";
              }
            ];
          }];
        };

        turn = {
          turn_uris = [
            "turn:${config.services.coturn.realm}:3478?transport=udp"
            "turn:${config.services.coturn.realm}:3478?transport=tcp"
          ];
          turn_shared_secret = config.services.coturn.static-auth-secret-file;
        };
      };

    };

    postgresql = {
      ensureDatabases = [ name ];
      ensureUsers = [{
        inherit name;
        ensureDBOwnership = true;
      }];
    };

    postgresqlBackup.databases = [ name ];

    nginx.virtualHosts = {
      ${domain_name} = {
        forceSSL = true;
        enableACME = true;
        locations."= /.well-known/matrix/client".alias = pkgs.writeText "matrix-client" (
          builtins.toJSON { "m.homeserver".base_url = "https://${server_name}"; }
        );
        locations."= /.well-known/matrix/server".extraConfig =
          let
            server."m.server" = "${server_name}:443";
          in
          ''
            add_header Content-Type application/json;
            return 200 '${builtins.toJSON server}';
          '';
      };

      ${server_name} = {
        forceSSL = true;
        enableACME = true;
        locations."/".proxyPass = "http://${bindHost}:${toString config.services.dendrite.httpPort}";
      };

      ${admin_domain} = {
        enableACME = true;
        forceSSL = true;
        locations."/".root = pkgs.synapse-admin;
      };

      ${chat_domain} = {
        enableACME = true;
        forceSSL = true;
        locations."/".root = pkgs.element-web.override {
          conf = {
            brand = "srx digital";
            branding = {
              welcome_background_url = "https://images.unsplash.com/photo-1480843669328-3f7e37d196ae?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
              auth_header_logo_url = "https://${domain_name}/favicon.svg";
            };
            default_server_config = {
              "m.homeserver" = {
                base_url = "https://${server_name}";
                server_name = "${server_name}";
              };
              "m.identity_server".base_url = "https://${server_name}";
            };
            help_url = "https://${domain_name}";
          };
        };
      };
    };

    prometheus.scrapeConfigs = [{
      job_name = "dendrite";
      scrape_interval = "60s";
      metrics_path = "/metrics";
      scheme = "http";
      static_configs = [{ targets = [ "${bindHost}:${toString config.services.dendrite.httpPort}" ]; }];
    }];

    telegraf.extraConfig.inputs = {
      x509_cert = [{
        sources = [ "https://${server_name}:443" ];
        tags.host = server_name;
        interval = "10m";
      }];

      http_response = [{
        urls = [ "https://${server_name}" ];
        tags.host = server_name;
        interval = "10m";
      }];
    };
  };

  systemd.services.dendrite = {
    serviceConfig.LoadCredential = [ "private_key:${config.age.secrets.dendritePrivateKey.path}" ];
    requires = [ "postgresql.service" "keycloak.service" ];
    after = [ "postgresql.service" "keycloak.service" ];
  };
}

