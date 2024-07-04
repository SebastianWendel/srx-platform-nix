{
  # smart_errors = {
  #   condition = ''smart_device_health_ok{enabled!="Disabled"} != 1'';
  #   description = "{{$labels.instance}}: S.M.A.R.T reports: {{$labels.device}} ({{$labels.model}}) has errors.";
  # };

  mdraid_not_active = {
    condition = ''node_md_state{state="active"} != 1'';
    description = "{{$labels.instance}} with device {{$labels.device}} is in {{$labels.state}}.";
  };

  mdraid_is_recovering = {
    condition = ''node_md_state{state="recovering"} == 1'';
    description = "{{$labels.instance}} with device {{$labels.device}} is in {{$labels.state}}.";
  };

  mdraid_disks_down = {
    condition = "mdstat_DisksDown != 0";
    description = "{{$labels.instance}} with device {{$labels.device}} is in {{$labels.state}}.";
  };

  mdraid_disks_faild = {
    condition = "mdstat_DisksFailed != 0";
    description = "{{$labels.instance}} with device {{$labels.device}} is in {{$labels.state}}.";
  };
}
