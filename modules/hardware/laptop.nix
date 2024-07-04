{ inputs, ... }:
{
  imports = with inputs; [
    nixos-hardware.nixosModules.common-pc-laptop-acpi_call
  ];
}
