{ lib, ... }:
{
  zramSwap.enable = lib.mkDefault true;
}
