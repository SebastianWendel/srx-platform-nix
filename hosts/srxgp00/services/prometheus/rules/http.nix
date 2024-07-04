{
  http = {
    condition = "http_response_result_code != 0";
    description = "{{$labels.server}} : http request failed from {{$labels.instance}}: {{$labels.result}}!";
  };

  # http_not_ok = {
  #   condition = "0 * (http_response_http_response_code != 200) + 1";
  #   description = "{{ $labels.exported_server }} does not return Ok for more than 5 minutes";
  # };

  # http_match_failed = {
  #   condition = "http_response_response_string_match == 0";
  #   description = "{{$labels.server}} : http body not as expected; status code: {{$labels.status_code}}!";
  # };
}
