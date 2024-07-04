{
  services.mosquitto = {
    enable = true;
    listeners = [{
      port = 1883;
      acl = [ "pattern readwrite #" ];
      settings = { allow_anonymous = true; };
    }];
  };
}
