{ pkgs, ... }:
{
  hardware = {
    rtl-sdr.enable = true;
    hackrf.enable = true;
  };

  environment.systemPackages = with pkgs;    [
    rtl-sdr
    rtl_433
  ];

  services.prometheus.exporters.rtl_433 = {
    enable = true;
    channels = [{
      channel = 6543;
      location = "Kitchen";
      name = "Acurite";
    }];
    ids = [{
      id = 1;
      location = "universe";
      name = "Werk2";
    }];
  };
}
