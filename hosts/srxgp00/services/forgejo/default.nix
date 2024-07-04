{ lib, config, ... }:
{
  # imports = [ ./runner.nix ];

  age.secrets.forgejoMailerPassword = {
    file = ./mailerPassword.age;
    owner = config.services.forgejo.user;
  };

  services = {
    forgejo = {
      enable = true;
      database.type = "postgres";
      mailerPasswordFile = config.age.secrets.forgejoMailerPassword.path;
      lfs.enable = true;

      settings = {
        # https://github.com/go-forgejo/forgejo/blob/main/custom/conf/app.example.ini
        DEFAULT.APP_NAME = "srx digital code base";

        server = {
          HTTP_PORT = 3030;
          HTTP_ADDR = "127.0.0.1";
          DOMAIN = "code.srx.digital";
          ROOT_URL = "https://${config.services.forgejo.settings.server.DOMAIN}/";
          LANDING_PAGE = "explore";
        };

        database.LOG_SQL = false;

        metrics = {
          ENABLED = true;
          ENABLED_ISSUE_BY_REPOSITORY = true;
          ENABLED_ISSUE_BY_LABEL = true;
        };

        service = {
          ENABLED_USER_HEATMAP = true;
          ENABLE_TIMETRACKING = true;
          REGISTER_EMAIL_CONFIRM = true;
          ENABLE_NOTIFY_MAIL = true;
          DEFAULT_KEEP_EMAIL_PRIVATE = true;
          ENABLE_CAPTCHA = true;
          CAPTCHA_TYPE = "image";
          VALID_SITE_URL_SCHEMES = "https";
        };

        mailer = {
          ENABLED = true;
          FROM = "no-reply@srx.digital";
          USER = "no-reply@srx.digital";
          SMTP_ADDR = "mail.srx.digital";
          PROTOCOL = "smtps";
          SMTP_PORT = 465;
        };

        cron = {
          ENABLED = true;
          RUN_AT_START = true;
        };

        api.ENABLED_SWAGGER = true;
        actions.ENABLED = true;
        picture.DISABLE_GRAVATAR = true;

        other = {
          SHOW_FOOTER_VERSION = false;
          SHOW_FOOTER_BRANDING = false;
          SHOW_FOOTER_TEMPLATE_LOAD_TIME = false;
        };
      };
    };

    nginx.virtualHosts."${toString config.services.forgejo.settings.server.DOMAIN}" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://${toString config.services.forgejo.settings.server.HTTP_ADDR}:${toString config.services.forgejo.settings.server.HTTP_PORT}";
    };

    postgresqlBackup.databases = lib.optionals config.services.forgejo.enable [
      config.services.forgejo.database.name
    ];

    prometheus.scrapeConfigs = [{
      job_name = "forgejo";
      scrape_interval = "60s";
      metrics_path = "/metrics";
      scheme = "https";
      static_configs = [{ targets = [ "${config.services.forgejo.settings.server.DOMAIN}" ]; }];
    }];

    telegraf.extraConfig.inputs = {
      x509_cert = [{
        sources = [ "https://${config.services.forgejo.settings.server.DOMAIN}:443" ];
        tags.host = config.services.forgejo.settings.server.DOMAIN;
        interval = "10m";
      }];

      http_response = [{
        urls = [ "https://${config.services.forgejo.settings.server.DOMAIN}" ];
        tags.host = config.services.forgejo.settings.server.DOMAIN;
        interval = "10m";
      }];
    };
  };

  networking.firewall.allowedTCPPorts = [ config.services.forgejo.settings.server.SSH_PORT ];
}
