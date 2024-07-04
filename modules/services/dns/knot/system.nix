{
  networking.firewall = {
    allowedTCPPorts = [ 53 853 ];
    allowedUDPPorts = [ 53 853 ];
  };

  boot.kernel.sysctl =
    let
      socket_bufsize = 1048576;
      busy_latency = 0;
      backlog = 40000;
      optmem_max = 20480;
    in
    {
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_tw_reuse" = 1;
      "net.core.wmem_max" = socket_bufsize;
      "net.core.wmem_default" = socket_bufsize;
      "net.core.rmem_max" = socket_bufsize;
      "net.core.rmem_default" = socket_bufsize;
      "net.core.busy_read" = busy_latency;
      "net.core.busy_poll" = busy_latency;
      "net.core.netdev_max_backlog" = backlog;
      "net.core.optmem_max" = optmem_max;
    };
}
