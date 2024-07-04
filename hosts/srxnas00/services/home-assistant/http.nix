{
  # https://www.home-assistant.io/integrations/http
  services.home-assistant.config.http = {
    server_host = "0.0.0.0";
    # trusted_proxies = ["10.80.0.10"];
    use_x_forwarded_for = true;
    ip_ban_enabled = true;
    login_attempts_threshold = 5;
  };
}
