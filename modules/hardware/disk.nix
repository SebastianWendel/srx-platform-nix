{ inputs, config, pkgs, lib, ... }:
{
  imports = with inputs; [
    nixos-hardware.nixosModules.common-pc-ssd
  ];

  environment = {
    etc."mdadm.conf".text = ''
      MAILADDR root
    '';

    systemPackages = with pkgs; [
      hdparm
      sdparm
      nvme-cli
      smartmontools
    ];
  };

  hardware.sensor.hddtemp = {
    enable = lib.mkDefault true;
    drives = [ "/dev/disk/by-path/*" ];
  };

  services = {
    smartd = {
      enable = lib.mkDefault true;
      notifications = {
        mail.enable = lib.mkIf config.services.postfix.enable true;
        x11.enable = lib.mkIf config.services.xserver.enable true;
      };
    };

    telegraf.extraConfig.inputs = lib.mkIf config.services.telegraf.enable {
      hddtemp = { };
      smart = {
        path_smartctl = lib.mkForce "${pkgs.smartmontools}/bin/smartctl";
        path_nvme = lib.mkForce "${pkgs.nvme-cli}/bin/nvme";
      };
    };
  };
}
