{
  # forgejo_http_500 = {
  #   condition = ''rate(promhttp_metric_handler_requests_total{job="forgejo", code="500"}[5m]) > 3'';
  #   description = "{{$labels.instance}}: forgejo instances error rate went up: {{$value}} errors in 5 minutes";
  # };
}
