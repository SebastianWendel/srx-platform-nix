{ config, ... }:
let
  host = "alerts.srx.digital";
in
{
  age.secrets.prometheusAlertmanagerEnv.file = ./alertmanager-env.age;

  services = {
    prometheus = {
      scrapeConfigs = [{
        job_name = "alertmanager";
        static_configs = [{
          targets = [ "${config.services.prometheus.alertmanager.listenAddress}:${toString config.services.prometheus.alertmanager.port}" ];
        }];
      }];

      alertmanager = {
        enable = true;
        webExternalUrl = "https://${host}";
        listenAddress = "localhost";

        environmentFile = config.age.secrets.prometheusAlertmanagerEnv.path;
        configuration = {
          global = {
            smtp_smarthost = "mail.srx.digital:587";
            smtp_auth_username = "$SMTP_USERNAME";
            smtp_auth_password = "$SMTP_PASSWORD";
            smtp_from = "$SMTP_USERNAME";
          };

          route = {
            receiver = "default";
            routes = [
              {
                receiver = "mail";
                group_by = [ "host" ];
                group_wait = "30s";
                group_interval = "2m";
                repeat_interval = "2h";
              }
              {
                receiver = "telegram";
                group_by = [ "host" ];
                group_wait = "30s";
                group_interval = "2m";
                repeat_interval = "2h";
              }
            ];
          };

          receivers = [
            { name = "default"; }
            {
              name = "mail";
              email_configs = [{
                to = "$SMTP_RECEIVER";
                send_resolved = true;
              }];
            }
            {
              name = "telegram";
              telegram_configs = [{
                bot_token = "$TELEGRAM_BOT_TOKEN";
                chat_id = -419206986;
                parse_mode = "HTML";
              }];
            }
          ];
        };
      };

      alertmanagers = [{
        scheme = "http";
        path_prefix = "/";
        static_configs = [{
          targets = [
            "${config.services.prometheus.alertmanager.listenAddress}:${toString config.services.prometheus.alertmanager.port}"
          ];
        }];
      }];
    };

    nginx.virtualHosts."${host}" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://${config.services.prometheus.alertmanager.listenAddress}:${toString config.services.prometheus.alertmanager.port}";
    };

    oauth2-proxy.nginx.virtualHosts."${host}" = {
      allowed_email_domains = [ "srx.digital" ];
    };

    telegraf.extraConfig.inputs = {
      x509_cert = [{
        sources = [ "https://${host}:443" ];
        tags.host = host;
        interval = "10m";
      }];

      http_response = [{
        urls = [ "https://${host}" ];
        tags.host = host;
        interval = "10m";
      }];
    };
  };
}
