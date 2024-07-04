{ pkgs, config, lib, ... }:
{
  environment.systemPackages = with pkgs;    [
    yubikey-personalization
  ] ++ lib.optionals config.services.xserver.enable [
    yubikey-manager-qt
    yubikey-personalization-gui
  ];

  security.pam.yubico = {
    enable = lib.mkDefault true;
    mode = "challenge-response";
  };

  services = {
    pcscd.enable = lib.mkDefault true;
    yubikey-agent.enable = lib.mkDefault true;
    udev.packages = with pkgs; [
      libu2f-host
      yubikey-personalization
    ];
  };
}
