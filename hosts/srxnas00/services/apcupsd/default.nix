{
  services = {
    apcupsd = {
      enable = true;

      configText = ''
        UPSTYPE usb
        NISIP 127.0.0.1
        BATTERYLEVEL 50
        MINUTES 5
      '';
    };

    prometheus.exporters.apcupsd.enable = true;
  };
}
