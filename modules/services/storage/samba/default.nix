{
  services.samba = {
    enable = true;
    openFirewall = true;
    securityType = "user";
    extraConfig = ''
      server string = %h
      workgroup = srx
      netbios name = %h

      logging = systemd
      log level = 1

      load printers = no

      server min protocol = SMB3
      client min protocol = SMB3

      aio read size = 16384
      aio write size = 16384

      security = user
      map to guest = bad user
      guest account = nobody
      invalid users = root
      force group = users
      create mask = 0660
      directory mask = 0770
    '';

    shares = {
      public = {
        comment = "public exchange share";
        path = "/srv/public";
        browseable = "yes";
        writeable = "yes";
        "guest ok" = "yes";
      };

      movies = {
        comment = "privat movie share";
        path = "/srv/movies";
        browseable = "yes";
        writeable = "yes";
        "guest ok" = "yes";
      };

      music = {
        comment = "privat music share";
        path = "/srv/music";
        browseable = "yes";
        writeable = "yes";
        "guest ok" = "yes";
      };

      home = {
        comment = "privat home share";
        path = "/srv/home";
        browseable = "yes";
        writeable = "yes";
        "guest ok" = "no";
      };

      documents = {
        comment = "privat document share";
        path = "/srv/documents";
        browseable = "yes";
        writeable = "yes";
        "guest ok" = "no";
      };

      pictures = {
        comment = "privat picture share";
        path = "/srv/pictures";
        browseable = "yes";
        writeable = "yes";
        "guest ok" = "no";
      };

      videos = {
        comment = "privat video share";
        path = "/srv/videos";
        browseable = "yes";
        writeable = "yes";
        "guest ok" = "no";
      };

      backups = {
        comment = "privat samba share.";
        path = "/srv/backups";
        browseable = "yes";
        writeable = "yes";
        "guest ok" = "no";
      };
    };
  };
}
