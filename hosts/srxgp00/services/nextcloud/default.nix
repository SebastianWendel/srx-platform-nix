{ config, pkgs, ... }:
{
  age.secrets = {
    nextcloudAdminPass = {
      file = ./adminpass.age;
      owner = "nextcloud";
    };

    nextcloudSecrets = {
      file = ./secrets.age;
      owner = "nextcloud";
    };
  };

  environment.systemPackages = with pkgs; [
    ffmpeg
    ocrmypdf
    tesseract
  ];

  services = {
    nextcloud = {
      enable = true;
      hostName = "cloud.srx.digital";

      package = pkgs.nextcloud29;
      extraAppsEnable = true;

      configureRedis = true;
      webfinger = true;
      https = true;
      maxUploadSize = "1024M";

      extraApps = {
        inherit (pkgs.nextcloud29Packages.apps) mail;
        inherit (pkgs.nextcloud29Packages.apps) contacts;
        inherit (pkgs.nextcloud29Packages.apps) calendar;
        inherit (pkgs.nextcloud29Packages.apps) deck;
        inherit (pkgs.nextcloud29Packages.apps) forms;
        inherit (pkgs.nextcloud29Packages.apps) polls;
        oidc_login = pkgs.fetchNextcloudApp {
          url = "https://github.com/pulsejet/nextcloud-oidc-login/releases/download/v3.1.1/oidc_login.tar.gz";
          sha256 = "sha256-EVHDDFtz92lZviuTqr+St7agfBWok83HpfuL6DFCoTE=";
          license = "gpl3";
        };
      };

      phpOptions = {
        post_max_size = "1024M";
        upload_max_filesize = "1024M";
        expose_php = "Off";
        short_open_tag = "Off";
        catch_workers_output = "yes";
        display_errors = "stderr";
        error_reporting = "E_ALL & ~E_DEPRECATED & ~E_STRICT";
        "opcache.enable_cli" = "1";
        "opcache.fast_shutdown" = "1";
        "opcache.interned_strings_buffer" = "16";
        "opcache.max_accelerated_files" = "10000";
        "opcache.memory_consumption" = "1024";
        "opcache.revalidate_freq" = "1";
        "openssl.cafile" = "/etc/ssl/certs/ca-certificates.crt";
      };

      poolSettings = {
        "pm" = "dynamic";
        "pm.max_children" = "512";
        "pm.max_requests" = "4096";
        "pm.max_spare_servers" = "512";
        "pm.min_spare_servers" = "32";
        "pm.start_servers" = "64";
      };

      config = {
        dbtype = "pgsql";
        dbhost = "/run/postgresql";
        adminuser = "service";
        adminpassFile = config.age.secrets.nextcloudAdminPass.path;
      };

      secretFile = config.age.secrets.nextcloudSecrets.path;

      settings = {
        overwriteProtocol = "https";
        default_phone_region = "+49";
        oidc_login_client_id = "cloud";
        oidc_login_provider_url = "https://id.srx.digital/realms/srx";
        oidc_login_logout_url = "https://${config.services.nextcloud.hostName}/apps/oidc.login/oidc";
        oidc_login_scope = "openid email profile roles";
        oidc_login_attributes = {
          id = "preferred_username";
          mail = "email";
        };
        oidc_create_groups = true;
        oidc_login_auto_redirect = true;
        oidc_login_button_text = "Log in with OpenID";
        oidc_login_disable_registration = false;
        oidc_login_end_session_redirect = true;
        oidc_login_hide_password_form = true;
        oidc_login_redir_fallback = true;
        oidc_login_update_avatar = false;
        allow_user_to_change_display_name = false;
        lost_password_link = "disabled";
        overwritehost = config.services.nextcloud.hostName;
        "htaccess.IgnoreFrontController" = true;
      };
    };

    postgresql = {
      ensureDatabases = [ config.services.nextcloud.config.dbname ];
      ensureUsers = [{
        name = config.services.nextcloud.config.dbuser;
        ensureDBOwnership = true;
      }];
    };

    postgresqlBackup.databases = [ "nextcloud" ];


    nginx.virtualHosts = {
      "${config.services.nextcloud.hostName}" = {
        forceSSL = true;
        enableACME = true;
      };

      "srx.digital".locations = {
        "= /.well-known/carddav".return = "301 https://${config.services.nextcloud.hostName}/remote.php/dav";
        "= /.well-known/caldav".return = "301 https://${config.services.nextcloud.hostName}/remote.php/dav";
        "= /.well-known/webdav".return = "301 https://${config.services.nextcloud.hostName}/remote.php/dav";
      };
    };

    telegraf.extraConfig.inputs = {
      x509_cert = [{
        sources = [ "https://${config.services.nextcloud.hostName}:443" ];
        tags.host = config.services.nextcloud.hostName;
        interval = "10m";
      }];

      http_response = [{
        urls = [ "https://${config.services.nextcloud.hostName}" ];
        tags.host = config.services.nextcloud.hostName;
        interval = "10m";
      }];
    };
  };

  systemd.services.nextcloud-setup = {
    wantedBy = [ "multi-user.target" ];
    requires = [ "postgresql.service" ];
    after = [ "network.target" "postgresql.service" ];
  };
}
