{ self, pkgs, lib, ... }:
{
  imports = [
    self.nixosModules.hardware-disk
    self.nixosModules.hardware-power
    self.nixosModules.hardware-bluetooth
  ];

  hardware = {
    ksm.enable = lib.mkDefault true;
    i2c.enable = lib.mkDefault true;
    enableRedistributableFirmware = lib.mkDefault true;
  };

  services = {
    fwupd.enable = true;
    thermald.enable = lib.mkIf (pkgs.hostPlatform.system == "x86_64-linux") true;

    telegraf.extraConfig.inputs = {
      linux_cpu = { };
      sensors = { };
      temp = { };
    };
  };

  programs.usbtop.enable = lib.mkDefault true;

  environment.systemPackages = with pkgs; [
    dmidecode
    freeipmi
    lm_sensors
    lshw
    pciutils
    usbutils
  ];

  systemd.services.telegraf.path = with pkgs; [ lm_sensors ];
}
