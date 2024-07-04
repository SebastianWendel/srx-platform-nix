{
  apcupsd_line_volts = {
    condition = "apcupsd_line_volts < 200";
    description = "The UPS line voltage on {{$labels.instance}} dropped below 200V, indicating a potential blackout: {{$value}} V!";
  };

  apcupsd_battery_volts = {
    condition = "apcupsd_battery_volts < 20";
    description = "The UPS battery voltage on {{$labels.instance}} dropped below 20V: {{$value}} V!";
  };

  apcupsd_battery_volts_nominal = {
    condition = "apcupsd_battery_nominal_volts < 20";
    description = "The nominal UPS battery voltage on {{$labels.instance}} dropped below 20V: {{$value}} V!";
  };

  apcupsd_temperature = {
    condition = "apcupsd_internal_temperature_celsius > 40";
    description = "The internal UPS temperature on {{$labels.instance}} exceeds 40°C: {{$value}}°C!";
  };

  apcupsd_ups_load = {
    condition = "apcupsd_ups_load_percent > 80";
    description = "The UPS load on {{$labels.instance}} is higher than 80%: {{$value}}%!";
  };

  apcupsd_battery_time_left = {
    condition = "apcupsd_battery_time_left_seconds < 600";
    description = "Less than 10 minutes of UPS battery charge remaining on {{$labels.instance}}: {{$value}} seconds!";
  };

  apcupsd_battery_charge = {
    condition = "apcupsd_battery_charge_percent < 80";
    description = "Less than 80% battery charge remaining on {{$labels.instance}}: {{$value}}%!";
  };

  apcupsd_status_not_online = {
    condition = ''apcupsd_info{status != "ONLINE"}'';
    description = "The UPS status on {{$labels.instance}} is not online: {{$labels.status}}!";
  };
}
