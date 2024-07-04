{ config, ... }:
{
  services = {
    promtail = {
      enable = true;
      configuration = {
        server = {
          http_listen_address = "0.0.0.0";
          http_listen_port = 9080;
          grpc_listen_port = 0;
        };
        clients = [{ url = "http://logs.vpn.srx.dev:3100/loki/api/v1/push"; }];
        scrape_configs = [{
          job_name = "journal";
          journal = {
            json = true;
            max_age = "12h";
            labels.job = "systemd-journal";
          };
          pipeline_stages = [
            { json.expressions = { transport = "_TRANSPORT"; unit = "_SYSTEMD_UNIT"; msg = "MESSAGE"; coredump_cgroup = "COREDUMP_CGROUP"; coredump_exe = "COREDUMP_EXE"; coredump_cmdline = "COREDUMP_CMDLINE"; coredump_uid = "COREDUMP_UID"; coredump_gid = "COREDUMP_GID"; }; }
            { labels.coredump_unit = "coredump_unit"; }
            { template = { source = "msg"; template = "{{if .coredump_exe}}{{.coredump_exe}} core dumped (user: {{.coredump_uid}}/{{.coredump_gid}}, command: {{.coredump_cmdline}}){{else}}{{.msg}}{{end}}"; }; }
            { template = { source = "unit"; template = "{{if .unit}}{{.unit}}{{else}}{{.transport}}{{end}}"; }; }
            { replace = { source = "unit"; expression = "^(session-\\d+.scope)$"; replace = "session.scope"; }; }
            { regex = { expression = "(?P<coredump_unit>[^/]+)$"; source = "coredump_cgroup"; }; }
            { labels.unit = "unit"; }
            { output.source = "msg"; }
          ];
          relabel_configs = [
            { source_labels = [ "__journal__systemd_unit" ]; target_label = "unit"; }
            { source_labels = [ "__journal__transport" ]; target_label = "transport"; }
            { source_labels = [ "__journal__hostname" ]; target_label = "host"; }
          ];
        }];
      };
    };

    prometheus.scrapeConfigs = [{
      job_name = "promtail";
      static_configs = [{
        targets = [
          "${config.services.promtail.configuration.server.http_listen_address}:${toString config.services.promtail.configuration.server.http_listen_port}"
        ];
      }];
    }];
  };
}
