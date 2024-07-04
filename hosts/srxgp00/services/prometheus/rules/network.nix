{
  ## ssh: connect to host srxgp00.srx.digital port 22: Connection refused
  # connection_failed = {
  #   condition = "net_response_result_code != 0";
  #   description = "{{$labels.server}}: connection to {{$labels.port}}({{$labels.protocol}}) failed from {{$labels.instance}}";
  # };

  # ping = {
  #   condition = "ping_result_code != 0";
  #   description = "{{$labels.url}}: ping from {{$labels.instance}} has failed!";
  # };

  # ping_high_latency = {
  #   condition = "ping_average_response_ms > 5000";
  #   description = "{{$labels.instance}}: ping probe from {{$labels.source}} is encountering high latency!";
  # };
}
