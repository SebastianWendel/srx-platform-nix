{ pkgs, ... }:
{
  # services.vdr = {
  #   enable = true;

  #   package = pkgs.wrapVdr.override {
  #     plugins = with pkgs.vdrPlugins; [
  #       epgsearch
  #       femon
  #       markad
  #       streamdev
  #       vnsiserver
  #     ];
  #   };
  #   videoDir = "/srv/videos/vdr";
  # };

  services.tvheadend.enable = true;
  # services.antennas.enable = true;

  environment.systemPackages = with pkgs; [
    dtv-scan-tables
    dvb-apps
    w_scan2
  ];
}
