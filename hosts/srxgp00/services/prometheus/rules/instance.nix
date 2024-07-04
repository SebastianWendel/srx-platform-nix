{
  instance_down = {
    condition = "up == 0";
    time = "5m";
    description = "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes.";
  };

  instance_reboot = {
    condition = "system_uptime < 300";
    description = "{{$labels.host}} just rebooted.";
  };

  instance_uptime = {
    condition = "system_uptime > 2592000";
    description = "{{$labels.host}} has been up for more than 30 days.";
  };
}
