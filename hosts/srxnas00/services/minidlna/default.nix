{
  users.users.minidlna.extraGroups = [ "users" ];

  services.minidlna = {
    enable = true;
    openFirewall = true;

    settings = {
      inotify = "yes";
      friendly_name = "srx";

      media_dir = [
        "V,/srv/movies"
        "A,/srv/music"
      ];

      extraConfig = ''
        enable_tivo=no
        max_connections=50
      '';
    };
  };
}
