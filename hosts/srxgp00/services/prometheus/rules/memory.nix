{
  memory_under_pressure = {
    condition = "rate(node_vmstat_pgmajfault[1m]) > 1000";
    description = "{{$labels.instance}}: The node is under heavy memory pressure. High rate of major page faults: {{$value}}";
  };

  ram_using_90percent = {
    condition = "mem_buffered + mem_free + mem_cached < mem_total * 0.1";
    time = "1h";
    description = "{{$labels.host}} is using at least 90% of its RAM for at least 1 hour.";
  };

  swap_using_30percent = {
    condition = "mem_swap_total - (mem_swap_cached + mem_swap_free) > mem_swap_total * 0.3";
    time = "30m";
    description = "{{$labels.host}} is using 30% of its swap space for at least 30 minutes.";
  };
}
