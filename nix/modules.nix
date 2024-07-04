{ self, ... }:
let
  inherit (builtins) listToAttrs replaceStrings stringLength substring;

  removeSuffix = suffix: str:
    let
      sufLen = stringLength suffix;
      sLen = stringLength str;
    in
    if sufLen <= sLen && suffix == substring (sLen - sufLen) sufLen str then
      substring 0 (sLen - sufLen) str
    else
      str;

  exposeModules = baseDir: paths:
    let
      prefix = stringLength (toString baseDir) + 1;
      toPair = path: {
        name = replaceStrings [ "/" ] [ "-" ] (
          removeSuffix ".nix" (substring prefix 100000000 (toString path))
        );
        value = path;
      };
    in
    listToAttrs (map toPair paths);
in
{
  flake = {
    modules.nixos = exposeModules ../modules/. [
      ../modules/custom/dns/knot
      ../modules/custom/dns/zones
      ../modules/filesystems/zfs.nix
      ../modules/hardware
      ../modules/hardware/bluetooth.nix
      ../modules/hardware/cpu/amd.nix
      ../modules/hardware/cpu/intel.nix
      ../modules/hardware/disk.nix
      ../modules/hardware/gpu/amd.nix
      ../modules/hardware/gpu/intel.nix
      ../modules/hardware/gpu/nvidia.nix
      ../modules/hardware/laptop.nix
      ../modules/hardware/power.nix
      ../modules/hardware/rpi4.nix
      ../modules/hardware/security/nitrokey.nix
      ../modules/hardware/security/secureboot.nix
      ../modules/hardware/security/yubikey.nix
      ../modules/hardware/sound/pipewire.nix
      ../modules/hardware/sound/pulseaudio.nix
      ../modules/roles/core
      ../modules/roles/desktop
      ../modules/roles/desktop/desktop-manager
      ../modules/roles/desktop/desktop-manager/gnome.nix
      ../modules/roles/desktop/display-manager
      ../modules/roles/desktop/office
      ../modules/roles/desktop/system
      ../modules/roles/desktop/window-manager
      ../modules/roles/media-center
      ../modules/roles/nas
      ../modules/roles/server
      ../modules/roles/workstation
      ../modules/services/container
      ../modules/services/container/docker.nix
      ../modules/services/container/k3s
      ../modules/services/container/podman.nix
      ../modules/services/database/mysql.nix
      ../modules/services/database/postgresql.nix
      ../modules/services/dns
      ../modules/services/dns/avahi.nix
      ../modules/services/dns/knot
      ../modules/services/dns/knsupdate.nix
      ../modules/services/monitoring
      ../modules/services/monitoring/loki.nix
      ../modules/services/monitoring/prometheus.nix
      ../modules/services/monitoring/promtail.nix
      ../modules/services/monitoring/telegraf.nix
      ../modules/services/netboot
      ../modules/services/netboot/config.nix
      ../modules/services/security/clamav
      ../modules/services/security/tang
      ../modules/services/storage/samba
      ../modules/services/storage/syncthing
      ../modules/services/virtualisation/libvirt.nix
      ../modules/services/virtualisation/microvm.nix
      ../modules/services/web/nginx.nix
      ../modules/users
      ../modules/users/personal/crstl
      ../modules/users/system/automat
      ../modules/users/system/root
      ../modules/users/system/service.nix
    ];

    nixosModules = self.modules.nixos;
  };
}
