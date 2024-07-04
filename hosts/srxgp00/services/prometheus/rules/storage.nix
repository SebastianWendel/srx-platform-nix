{
  filesystem_device_error = {
    condition = ''node_filesystem_device_error{fstype!="tmpfs",fstype!="ramfs",device_error!="permission denied"}  != 0'';
    time = "5m";
    description = "{{ $labels.instance }} with device {{ $labels.device }} of filesystem type {{ $labels.fstype }} has an error for more than 5 minutes.";
  };

  filesystem_full_80percent = {
    condition = ''disk_used_percent{mode!="ro", path!="/boot"} >= 80'';
    time = "10m";
    description = "{{$labels.instance}} device {{$labels.device}} on {{$labels.path}} got less than 20% space left on its filesystem.";
  };

  filesystem_inodes_full = {
    condition = "disk_inodes_free / disk_inodes_total < 0.10";
    time = "10m";
    description = "{{$labels.instance}} device {{$labels.device}} on {{$labels.path}} got less than 10% inodes left on its filesystem.";
  };

  filesystem_tmpfs_root_full = {
    condition = ''node_filesystem_free_bytes{fstype="tmpfs",mountpoint="/"} <= 128000000'';
    time = "10m";
    description = "{{$labels.host}}: {{$labels.name}} only 128MB left on / tmpfs filesystem.";
  };

  unusual_disk_read_latency = {
    condition = "rate(diskio_read_time[1m]) / rate(diskio_reads[1m]) > 0.1 and rate(diskio_reads[1m]) > 0";
    description = ''
      {{$labels.instance}}: Disk latency is growing (read operations > 100ms)
    '';
  };

  unusual_disk_write_latency = {
    condition = "rate(diskio_write_time[1m]) / rate(diskio_write[1m]) > 0.1 and rate(diskio_write[1m]) > 0";
    description = ''
      {{$labels.instance}}: Disk latency is growing (write operations > 100ms)
    '';
  };

  ext4_errors = {
    condition = "ext4_errors_value > 0";
    description = "{{$labels.instance}}: ext4 has reported {{$value}} I/O errors: check /sys/fs/ext4/*/errors_count";
  };

  zfs_zpool_errors = {
    condition = "zpool_status_errors > 0";
    description = "{{$labels.instance}} reports: zpool {{$labels.name}} has {{$value}} errors";
  };

  zfs_errors = {
    condition = "zfs_arcstats_l2_io_error + zfs_dmu_tx_error + zfs_arcstats_l2_writes_error > 0";
    description = "{{$labels.instance}} reports: {{$value}} ZFS IO errors.";
  };

  nfs_export_not_present = {
    condition = "nfs_export_present == 0";
    time = "1h";
    description = "{{$labels.host}} cannot reach nfs export [{{$labels.server}}]:{{$labels.path}}";
  };
}
