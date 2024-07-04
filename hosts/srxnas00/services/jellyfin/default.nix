{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "users";
  };
}
