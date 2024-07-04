{
  services.home-assistant.config = {
    homeassistant = {
      name = "SRX";
      unit_system = "metric";
      time_zone = "Europe/Berlin";
      temperature_unit = "C";
      latitude = "53.5527778";
      longitude = "9.9611111";
      elevation = 13;
    };

    zone = [
      {
        name = "Wohlwill";
        icon = "mdi:flower";
        latitude = "53.5527778";
        longitude = "9.9611111";
        radius = "200";
      }
    ];
  };
}
