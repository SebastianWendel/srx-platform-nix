{
  prometheus_wal_corruption = {
    condition = ''prometheus_tsdb_wal_corruptions_total > 1'';
    description = "Prometheus TSDB database has a corrupt Write-Ahead Log (WAL) of {{ $value }}.";
  };

  prometheus_too_many_restarts = {
    condition = ''changes(process_start_time_seconds{job=~"prometheus|pushgateway|alertmanager|telegraf"}[15m]) > 2'';
    description = "Prometheus has restarted more than twice in the last 15 minutes. It might be crashlooping.";
  };

  prometheus_not_connected_to_alertmanager = {
    condition = "prometheus_notifications_alertmanagers_discovered < 1";
    description = "Prometheus cannot connect the alertmanager VALUE = {{ $value }} LABELS = {{ $labels }}";
  };

  prometheus_rule_evaluation_failures = {
    condition = "increase(prometheus_rule_evaluation_failures_total[3m]) > 0";
    description =
      "Prometheus encountered {{ $value }} rule evaluation failures, leading to potentially ignored alerts. VALUE = {{ $value }} LABELS = {{ $labels }}";
  };

  prometheus_template_expansion_failures = {
    condition = "increase(prometheus_template_text_expansion_failures_total[3m]) > 0";
    time = "0m";
    description = "Prometheus encountered {{ $value }} template text expansion failures VALUE = {{ $value }} LABELS = {{ $labels }}";
  };

  prometheus_alertmanager_config_not_synced = {
    condition = ''count(count_values("config_hash", alertmanager_config_hash)) > 1'';
    description = "Configurations of AlertManager cluster instances are out of sync.";
  };

  # prometheus_alerts_silences_changed = {
  #   condition = ''abs(delta(alertmanager_silences{state="active"}[1h])) >= 1'';
  #   description = "alertmanager: number of active silences has changed: {{$value}}";
  # };
}
