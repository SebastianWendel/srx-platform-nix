{ config, ... }:
{
  services = {
    loki = {
      enable = true;
      configuration = rec {
        server = {
          http_listen_address = "0.0.0.0";
          http_listen_port = 3100;
        };

        auth_enabled = false;

        common = {
          ring = {
            instance_addr = server.http_listen_address;
            kvstore.store = "inmemory";
          };
          replication_factor = 1;
        };

        ingester = {
          lifecycler = {
            address = server.http_listen_address;
            final_sleep = "0s";
          };

          chunk_idle_period = "1h";
          max_chunk_age = "1h";
          chunk_target_size = 1048576;
          chunk_retain_period = "30s";
        };

        schema_config.configs = [
          {
            from = "2020-10-24";
            store = "boltdb-shipper";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];

        storage_config = {
          filesystem.directory = "${config.services.loki.dataDir}/chunks";
          boltdb_shipper = {
            active_index_directory = "${config.services.loki.dataDir}/active_index";
            cache_location = "${config.services.loki.dataDir}/cache";
            cache_ttl = "24h";
          };
        };

        limits_config = {
          reject_old_samples = true;
          reject_old_samples_max_age = "168h";
          allow_structured_metadata = false;
          split_queries_by_interval = "24h";
        };

        table_manager = {
          retention_deletes_enabled = false;
          retention_period = "0s";
        };

        compactor.working_directory = "${config.services.loki.dataDir}/compactor";

        query_range.cache_results = true;

        memberlist.join_members = [ "logs.vpn.srx.dev:${server.http_listen_address}" ];
      };
    };

    prometheus.scrapeConfigs = [{
      job_name = "loki";
      static_configs = [{
        targets = [
          "${config.services.loki.configuration.server.http_listen_address}:${toString config.services.loki.configuration.server.http_listen_port}"
        ];
      }];
    }];

    grafana.provision.datasources.settings.datasources = [{
      name = "Loki";
      type = "loki";
      access = "proxy";
      url = "http://${config.services.loki.configuration.server.http_listen_address}:${toString config.services.loki.configuration.server.http_listen_port}";
      jsonData = { timeout = 60; maxLines = 1000; };
    }];
  };
}

