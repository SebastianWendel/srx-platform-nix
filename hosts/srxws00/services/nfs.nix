{
  fileSystems = {
    "/mnt/home" = {
      device = "srxnas01.op.hq.hh.srx.dev:/export/mnt";
      fsType = "nfs";
      options = [
        "noauto"
        "X-mount.mkdir"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
      ];
    };

    "/mnt/backup" = {
      device = "srxnas01.op.hq.hh.srx.dev:/export/backup";
      fsType = "nfs";
      options = [
        "noauto"
        "X-mount.mkdir"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
      ];
    };

    "/mnt/pictures" = {
      device = "srxnas01.op.hq.hh.srx.dev:/export/pictures";
      fsType = "nfs";
      options = [
        "noauto"
        "X-mount.mkdir"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
      ];
    };

    "/mnt/music" = {
      device = "srxnas01.op.hq.hh.srx.dev:/export/music";
      fsType = "nfs";
      options = [
        "noauto"
        "X-mount.mkdir"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
      ];
    };

    "/mnt/videos" = {
      device = "srxnas01.op.hq.hh.srx.dev:/export/videos";
      fsType = "nfs";
      options = [
        "noauto"
        "X-mount.mkdir"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
      ];
    };

    "/mnt/movies" = {
      device = "srxnas01.op.hq.hh.srx.dev:/export/movies";
      fsType = "nfs";
      options = [
        "noauto"
        "X-mount.mkdir"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
      ];
    };
  };
}
