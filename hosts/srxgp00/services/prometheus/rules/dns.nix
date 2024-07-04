{
  dns_query = {
    condition = "dns_query_result_code != 0";
    description = "{{$labels.domain}} : could retrieve A record {{$labels.instance}} from server {{$labels.server}}: {{$labels.result}}!";
  };

  dns_secure_query = {
    condition = "secure_dns_state != 0";
    description = "{{$labels.domain}} : could retrieve A record {{$labels.instance}} from server {{$labels.server}}: {{$labels.result}} for protocol {{$labels.protocol}}!";
  };

  dnssec_zone_days_left = {
    condition = "dnssec_zone_record_resolves == 1 and dnssec_zone_record_days_left <= 10";
    description = "{{$labels.domain}} : could retrieve A record {{$labels.instance}} from server {{$labels.server}}: {{$labels.result}} for protocol {{$labels.protocol}}!";
  };
}
