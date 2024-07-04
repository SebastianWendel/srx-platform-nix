{ lib, ... }:
{
  networking.nameservers = lib.mkDefault [
    "1.1.1.1"
    "9.9.9.9"
    "2606:4700:4700::1111"
  ];

  services.resolved.enable = lib.mkDefault true;
}
