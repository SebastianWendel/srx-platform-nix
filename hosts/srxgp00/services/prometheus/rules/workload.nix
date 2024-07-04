{
  load15 = {
    condition = "system_load15 / system_n_cpus >= 2.0";
    time = "10m";
    description = "{{$labels.host}} is running with load15 > 1 for at least 5 minutes: {{$value}}";
  };
}
