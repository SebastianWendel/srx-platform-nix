{
  services.avahi = {
    enable = true;
    ipv4 = true;
    ipv6 = true;
    nssmdns4 = true;
    nssmdns6 = true;
    publish = {
      enable = true;
      userServices = true;
      workstation = true;
    };
  };
}
