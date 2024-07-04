{ config, ... }:
{
  age.secrets = {
    mailBoxDmarc.file = ./mailbox-dmarc.age;
    mailBoxDmarcClient = {
      file = ./mailbox-dmarc-client.age;
      owner = config.services.prometheus.exporters.dmarc.user;
    };
  };

  mailserver.loginAccounts."dmarc@srx.digital".hashedPasswordFile =
    config.age.secrets.mailBoxDmarc.path;

  services.prometheus = {
    exporters.dmarc = {
      enable = true;
      imap = {
        host = "mail.srx.digital";
        username = "dmarc@srx.digital";
        passwordFile = config.age.secrets.mailBoxDmarcClient.path;
      };
    };
    scrapeConfigs = [{
      job_name = "dmarc";
      scrape_interval = "60s";
      metrics_path = "/metrics";
      static_configs = [{
        targets = [
          "${config.services.prometheus.exporters.dmarc.listenAddress}:${toString config.services.prometheus.exporters.dmarc.port}"
        ];
      }];
    }];
  };
}
