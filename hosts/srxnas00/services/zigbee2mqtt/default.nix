{
  users.users.zigbee2mqtt.extraGroups = [ "dialout" ];

  services.zigbee2mqtt = {
    enable = true;

    settings = {
      serial.port = "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0";

      permit_join = true;

      homeassistant = {
        discovery_topic = "homeassistant";
        status_topic = "homeassistant/status";
      };

      availability = {
        active.timeout = 10;
        passive.timeout = 1500;
      };

      mqtt = {
        server = "mqtt://localhost:1883";
        include_device_information = true;
        keepalive = 60;
      };

      advanced = {
        output = "json";
        log_level = "info";
      };
    };
  };
}
