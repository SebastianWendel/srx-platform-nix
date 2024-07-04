{
  # cert_expiry = {
  #   # condition = "x509_cert_expiry < 7*24*3600";
  #   # description = "{{$labels.instance}}: The TLS certificate from {{$labels.source}} will expire in less than 7 days: {{$value}}s";
  #   condition = ''x509_cert_expiry{issuer_common_name="R3"} < ${toString (60 * 60 * 24 * 5)}'';
  #   description = "{{ $labels.san }} does expire in less than 5 days";
  # };
}
