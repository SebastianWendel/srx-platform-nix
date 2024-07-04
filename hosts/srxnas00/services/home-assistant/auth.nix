{
  services.home-assistant.config.homeassistant.auth_providers = [
    { type = "homeassistant"; }
    {
      type = "trusted_networks";
      trusted_networks = [ "10.50.0.0/23" "192.168.178.0/24" ];
      allow_bypass_login = true;
    }
  ];
}
