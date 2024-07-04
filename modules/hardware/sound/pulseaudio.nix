{ lib, pkgs, ... }:
{
  sound.enable = lib.mkForce true;
  hardware.pulseaudio = {
    enable = lib.mkForce true;
    package = pkgs.pulseaudioFull;
    extraConfig = ''
      load-module module-bluetooth-discover
      load-module module-bluetooth-policy
      load-module module-switch-on-connect
      load-module module-zeroconf-discover
      load-module module-stream-restore
    '';
  };
}
