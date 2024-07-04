{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    acpica-tools
    powertop
  ];

  services.acpid.enable = lib.mkDefault true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
}
