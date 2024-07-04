{

  age.secrets.cifsNas.file = ../../cifs_nas.age;

  fileSystems = {
    "/mnt/movies" = {
      device = "//192.168.178.71/movies";
      fsType = "cifs";
      options = [
        "noauto"
        "X-mount.mkdir"
        "x-systemd.automount"
        "x-systemd.device-timeout=5s"
        "x-systemd.idle-timeout=60"
        "x-systemd.mount-timeout=5s"
        "credentials=/run/agenix/cifsNas"
      ];
    };

    "/mnt/videos" = {
      device = "//192.168.178.71/videos";
      fsType = "cifs";
      options = [
        "noauto"
        "X-mount.mkdir"
        "x-systemd.automount"
        "x-systemd.device-timeout=5s"
        "x-systemd.idle-timeout=60"
        "x-systemd.mount-timeout=5s"
        "credentials=/run/agenix/cifsNas"
      ];
    };

    "/mnt/music" = {
      device = "//192.168.178.71/music";
      fsType = "cifs";
      options = [
        "noauto"
        "X-mount.mkdir"
        "x-systemd.automount"
        "x-systemd.device-timeout=5s"
        "x-systemd.idle-timeout=60"
        "x-systemd.mount-timeout=5s"
        "credentials=/run/agenix/cifsNas"
      ];
    };
  };
}
