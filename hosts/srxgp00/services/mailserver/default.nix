{ lib, config, inputs, ... }:
let
  host = "mail.srx.digital";
in
{
  imports = with inputs; [
    srx-nixos-shadow.nixosModules.mail
    simple-nixos-mailserver.nixosModule

    ./accounts.nix
    ./autoconfig.nix
    ./webclient.nix
    # ./dmarc.nix
  ];

  mailserver = {
    # https://nixos-mailserver.readthedocs.io/en/latest/options.html
    enable = true;
    fqdn = "${host}";

    domains = [
      "srx.dev"
      "srx.digital"
      "sourceindex.de"
      "nix-hamburg.de"
    ];

    enableImap = false;
    enablePop3 = false;
    enablePop3Ssl = true;

    enableManageSieve = lib.mkForce true;
    localDnsResolver = false;

    messageSizeLimit = 52428800;

    sieveDirectory = "/var/lib/sieve";
    mailDirectory = "/var/lib/vmail";
    dkimKeyDirectory = "/var/lib/dkim";
    certificateScheme = "acme-nginx";

    monitoring.enable = lib.mkForce false;

    backup = {
      enable = true;
      snapshotRoot = "/var/backup/mail";
    };

    fullTextSearch = {
      enable = true;
      autoIndex = true;
      indexAttachments = true;
      enforced = "yes";
      autoIndexExclude = [
        "\\Trash"
        "\\Spam"
        "\\Junk"
      ];
      memoryLimit = 20480;
    };

    policydSPFExtraConfig = ''
      skip_addresses = 10.0.0.0/16,127.0.0.0/8,::ffff:,::1
    '';
  };

  services = {
    dovecot2 = {
      mailPlugins.globally.enable = [ "old_stats" ];
      extraConfig = ''
        plugin {
          old_stats_refresh = 30 secs
          old_stats_track_cmds = yes
        }

        service old-stats {
          unix_listener old-stats {
            user = ${config.services.prometheus.exporters.dovecot.user}
            group = ${config.services.prometheus.exporters.dovecot.group}
            mode = 0660
          }

          fifo_listener old-stats-mail {
            mode = 0660
            user = ${config.services.dovecot2.user}
            group = ${config.services.dovecot2.group}
          }

          fifo_listener old-stats-user {
            mode = 0660
            user = ${config.services.dovecot2.user}
            group = ${config.services.dovecot2.group}
          }
        }

        metric imap_select_no {
          filter = event=imap_command_finished AND cmd_name=SELECT AND tagged_reply_state=NO
        }

        metric imap_select_no_notfound {
          filter = event=imap_command_finished AND cmd_name=SELECT AND tagged_reply="NO*Mailbox doesn't exist:*"
        }

        metric storage_http_gets {
          filter = event=http_request_finished AND category=storage AND method=get
        }

        metric imap_command {
          filter = event=imap_command_finished
          group_by = cmd_name tagged_reply_state
        }

        metric push_notifications {
          filter = event=push_notification_finished
        }
      '';
    };

    fail2ban = {
      enable = true;
      jails = {
        dovecot = ''
          enabled   = true
          filter    = dovecot[mode=aggressive]
          maxretry  = 5
        '';

        postfix = ''
          enabled   = true
          filter    = postfix
          maxretry  = 5
        '';

        postfix-sasl = ''
          enabled   = true
          filter    = postfix[mode=auth]
          maxretry  = 5
        '';
      };
    };

    prometheus = {
      exporters = {
        postfix.enable = true;
        dovecot = {
          enable = true;
          socketPath = "/var/run/dovecot2/old-stats";
        };
      };

      scrapeConfigs = [
        {
          job_name = "postfix";
          scrape_interval = "60s";
          metrics_path = "/metrics";
          static_configs = [
            { targets = [ "localhost:${toString config.services.prometheus.exporters.postfix.port}" ]; }
          ];
        }
        {
          job_name = "dovecot";
          scrape_interval = "60s";
          metrics_path = "/metrics";
          static_configs = [
            { targets = [ "localhost:${toString config.services.prometheus.exporters.dovecot.port}" ]; }
          ];
        }
      ];
    };
  };
}
