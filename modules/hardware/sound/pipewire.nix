{ lib, pkgs, ... }:
{
  hardware.pulseaudio.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [ pulseaudio ];

  security.rtkit.enable = lib.mkForce true;

  sound = {
    enable = lib.mkForce true;
    mediaKeys.enable = lib.mkForce true;
  };

  services.pipewire = {
    enable = lib.mkForce true;
    alsa.enable = lib.mkForce true;
    alsa.support32Bit = lib.mkForce true;
    pulse.enable = lib.mkForce true;
    wireplumber.enable = lib.mkForce true;
  };
}
