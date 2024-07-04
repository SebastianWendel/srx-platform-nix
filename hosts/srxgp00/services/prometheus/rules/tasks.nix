{
  daily_task_not_run = {
    condition = ''time() - task_last_run{state="ok",frequency="daily"} > (24 + 6) * 60 * 60'';
    description = "{{$labels.host}}: {{$labels.name}} was not run in the last 24h";
  };

  daily_task_failed = {
    condition = ''task_last_run{state="fail"}'';
    description = "{{$labels.host}}: {{$labels.name}} failed to run";
  };
}
