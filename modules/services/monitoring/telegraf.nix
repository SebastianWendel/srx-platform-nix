{ inputs, ... }:
{
  imports = with inputs; [
    srvos.nixosModules.mixins-telegraf
  ];

  services.telegraf = {
    enable = true;
    extraConfig = {
      inputs = {
        cpu = { };
        mem = { };
        swap = { };
        bond = { };
        disk = { };
        diskio = { };
        cgroup = { };
        system = { };
        conntrack = { };
        dns_query = { };
        filecount = { };
        hugepages = { };
        interrupts = { };
        iptables = { };
        kernel = { };
        netstat = { };
        nstat = { };
        processes = { };
        kernel_vmstat = { };
        systemd_units = { };
        internet_speed.interval = "60m";
      };
      outputs.prometheus_client.listen = ":9273";
    };
  };
}
