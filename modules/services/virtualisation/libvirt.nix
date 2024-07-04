{ lib, pkgs, config, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      virt-top
      ssh-askpass-fullscreen
      swtpm
    ]
    ++ lib.optionals config.services.xserver.enable [
      virt-manager
      spice-gtk
    ];

  networking.dhcpcd.denyInterfaces = [ "macvtap0@*" ];

  virtualisation = {
    libvirtd = {
      enable = true;

      qemu = {
        package = pkgs.qemu_kvm;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  services.telegraf.extraConfig.inputs.libvirt = lib.mkIf config.services.telegraf.enable { };

  users.users.telegraf = lib.mkIf config.services.telegraf.enable { extraGroups = [ "libvirtd" ]; };
}
