{
  home-manager.users.crstl.home.file = {
    # https://docs.syncthing.net/users/ignoring.html

    ".ssh/.stignore".text = ''
      config
    '';

    ".gnupg/.stignore".text = ''
      scdaemon.conf
      gpg-agent.conf
      gpg.conf
    '';

    ".mozilla/firefox/.stignore".text = ''
      profiles.ini
      default/.keep
      default/crashes
      default/lock
      default/user.js
      default/saved-telemetry-pings
      default/datareporting
      Crash\ Reports
      Pending\ Pings
    '';

    ".thunderbird/.stignore".text = ''
      profiles.ini
      default/.keep
      default/crashes
      default/lock
      default/user.js
      default/saved-telemetry-pings
      default/datareporting
      default/ImapMail
      Crash\ Reports
      Pending\ Pings
    '';

    ".config/FreeTube/.stignore".text = ''
      Cache
      Code\ Cache
      Cookies
      Cookies-journal
      Crashpad
      DawnCache
      Dictionaries
      GPUCache
      history.db
      hm_settings.db
      Local\ Storage
      Network\ Persistent\ State
      player_cache
      Preferences
      Session\ Storage
      Shared\ Dictionary
      SharedStorage
      SingletonCookie
      SingletonLock
      SingletonSocket
      TransportSecurity
      Trust\ Tokens
      Trust\ Tokens-journal
    '';
  };

  services.syncthing = {
    enable = true;

    user = "crstl";
    group = "crstl";
    dataDir = "/home/crstl";
    configDir = "/home/crstl/.config/syncthing";

    settings = {
      devices = {
        "srxnb00".id = "4WUQOIU-ZOQ37TB-WY5MVXP-CETPYMW-FX6LY2R-QHLIDS4-EIGNF4G-BLYJNQX";
        "srxws00".id = "PBB2S4Q-ZDZJWA7-3PCEKWO-6AE6QQE-WRTUYFT-KE7PSBK-UXHS5JL-GUWFNQ3";
        "srxws01".id = "LNHCHTQ-HXH23YW-VPUNSTC-O27IIJO-4SH6XWC-EKK4ISR-3TCJ6VX-F2H3HQ7";
        "srxtab00".id = "7TKI7YR-7Y4FDOW-UJI3MB5-UK2XRIG-XOQWCCP-KPZSBQB-6C43AN7-LVQUPQE";
        "srxnas00".id = "6RDN34T-S3QZW3Z-V6TV5LB-EQFHAX4-FUZK6GX-A2IGKNT-6GMF4PE-DBNQPQD";
        "srxnas01".id = "QHM4QIS-KES6PGM-VC4MSQF-L35G7HD-GV6S7FM-JUNLSED-TEU65J4-266IXAC";
      };

      folders =
        let
          ignorePerms = false;
          devices = [
            "srxnas00"
            "srxnas01"
            "srxtab00"
            "srxnb00"
            "srxws00"
            "srxws01"
          ];
        in
        {
          downloads = {
            path = "/home/crstl/Downloads";
            inherit devices ignorePerms;
          };

          music = {
            path = "/home/crstl/Music";
            inherit devices ignorePerms;
          };

          videos = {
            path = "/home/crstl/Videos";
            inherit devices ignorePerms;
          };

          documents = {
            path = "/home/crstl/Documents";
            inherit devices ignorePerms;
          };

          firefox = {
            path = "/home/crstl/.mozilla/firefox";
            inherit devices ignorePerms;
          };

          thunderbird = {
            path = "/home/crstl/.thunderbird";
            inherit devices ignorePerms;
          };

          freetube = {
            path = "/home/crstl/.config/FreeTube";
            inherit devices ignorePerms;
          };

          keyrings = {
            path = "/home/crstl/.local/share/keyrings";
            inherit devices ignorePerms;
          };

          passwords = {
            path = "/home/crstl/.password-store";
            inherit devices ignorePerms;
          };

          gpg = {
            path = "/home/crstl/.gnupg";
            inherit devices ignorePerms;
          };

          ssh = {
            path = "/home/crstl/.ssh";
            inherit devices ignorePerms;
          };

          goa = {
            path = "/home/crstl/.config/goa-1.0";
            inherit devices ignorePerms;
          };

          evolution = {
            path = "/home/crstl/.local/share/evolution";
            inherit devices ignorePerms;
          };
        };
    };
  };
}
