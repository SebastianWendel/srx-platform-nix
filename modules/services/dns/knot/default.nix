{
  imports = [
    ./modules.nix
    ./monitoring.nix
    ./system.nix
  ];

  services.knot = {
    enable = true;

    settings = {
      server = {
        listen = [ "0.0.0.0@53" "::@53" ];
        listen-quic = [ "0.0.0.0@853" ];
        tcp-reuseport = true;
        tcp-fastopen = true;
      };

      log.syslog.any = "info";

      database = {
        journal-db = "/var/lib/knot/journal";
        kasp-db = "/var/lib/knot/kasp";
        timer-db = "/var/lib/knot/timer";
      };

      keystore.default.backend = "pem";
    };
  };
}
