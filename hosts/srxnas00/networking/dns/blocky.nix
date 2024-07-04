{ config, ... }:
{
  networking.firewall.interfaces = {
    br_usr = {
      allowedUDPPorts = [ config.services.blocky.settings.ports.dns ];
      allowedTCPPorts = [ config.services.blocky.settings.ports.dns ];
    };
  };

  # networking.firewall.extraCommands = ''
  #   ip6tables --table nat --flush OUTPUT
  #   ${lib.flip (lib.concatMapStringsSep "\n") ["udp" "tcp"] (proto: ''
  #     ip6tables --table nat --append OUTPUT \
  #       --protocol ${proto} --destination ::1 --destination-port 53 \
  #       --jump REDIRECT --to-ports ${toString config.services.blocky.settings.ports.dns}
  #   '')}
  # '';

  services.blocky = {
    enable = true;
    settings = {
      # https://0xerr0r.github.io/blocky/configuration/

      upstreams = {
        groups = {
          default = [
            "https://dns.digitale-gesellschaft.ch/dns-query"
            "tcp-tls:dns2.digitalcourage.de:853"
            "tcp-tls:dns3.digitalcourage.de:853"
            "tcp-tls:fdns1.dismail.de:853"
            "tcp-tls:one.one.one.one:853"
          ];
          unencrypted = [
            "1.0.0.1"
            "1.1.1.1"
            "2606:4700:4700::1001"
            "2606:4700:4700::1111"
            "dns2.digitalcourage.de"
          ];
        };
        timeout = "2s";
      };

      startVerifyUpstream = true;
      connectIPVersion = "dual";

      blocking = {
        blackLists = {
          # https://disconnect.me/trackerprotection
          ads = [
            "http://sysctl.org/cameleon/hosts"
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
            "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
          ];
          fakenews = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews/hosts"
          ];
        };

        whiteLists = { };

        clientGroupsBlock = {
          default = [ "ads" ];
          sensitive = [
            "ads"
            "fakenews"
          ];
        };

        blockType = "zeroIp";
        blockTTL = "1m";

        loading = {
          downloads = {
            timeout = "4m";
            attempts = 5;
            cooldown = "10s";
          };
          refreshPeriod = "4h";
          strategy = "failOnError";
        };
      };

      filtering.queryTypes = [ ];

      caching = {
        minTime = "5m";
        maxTime = "30m";
        maxItemsCount = 0;
        prefetching = true;
        prefetchExpires = "2h";
        prefetchThreshold = 5;
        prefetchMaxItemsCount = 0;
        cacheTimeNegative = "30m";
      };

      ports = {
        dns = 53;
        http = 4040;
      };

      log = {
        level = "info";
        format = "text";
        timestamp = true;
        privacy = true;
      };

      hostsFile = {
        sources = [ "/etc/hosts" ];
        hostsTTL = "60m";
        filterLoopback = true;
        loading.refreshPeriod = "30m";
      };

      prometheus = {
        enable = true;
        path = "/metrics";
      };
    };
  };
}
