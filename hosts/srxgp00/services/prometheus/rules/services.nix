{
  systemd_service_failed = {
    condition = ''systemd_units_active_code{name!~"nixpkgs-update-.*.service"} == 3'';
    description = "{{$labels.host}} failed to (re)start service {{$labels.name}}.";
  };

  service_not_running = {
    condition = ''systemd_units_active_code{name=~"teamspeak3-server.service|tt-rss.service", sub!="running"}'';
    description = "{{$labels.host}} should have a running {{$labels.name}}.";
  };

  telegraf_down = {
    condition = ''min(up{job=~"telegraf"}) by (source, job, instance, org) == 0'';
    time = "3m";
    description = "{{$labels.instance}}: {{$labels.job}} telegraf exporter from {{$labels.source}} is down.";
  };

  oom_kills = {
    condition = "increase(kernel_vmstat_oom_kill[5m]) > 0";
    description = "{{$labels.instance}}: OOM kill detected";
  };
}
