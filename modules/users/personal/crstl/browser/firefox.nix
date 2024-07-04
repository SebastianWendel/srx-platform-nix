{ lib, pkgs, ... }:
let
  package = pkgs.firefox-wayland;
in
{
  programs.firefox = {
    enable = true;
    inherit package;
    profiles = {
      default = {
        isDefault = true;

        settings = {
          # https://kb.mozillazine.org/About:config_entries
          "app.update.auto" = false;
          "browser.newtab.url" = "about:blank";
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.newtabpage.pinned" = [
            {
              title = "NixOS";
              url = "https://nixos.org";
            }
          ];
          "browser.ping-centre.telemetry" = false;
          "browser.search.isUS" = false;
          "browser.search.region" = "DE";
          "browser.shell.checkDefaultBrowser" = false;
          "browser.startup.homepage" = "about:blank";
          "browser.uidensity" = 0;
          "distribution.searchplugins.defaultLocale" = "en-GB";
          "dom.security.https_only_mode_ever_enabled" = true;
          "dom.security.https_only_mode" = true;
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.supported" = false;
          "extensions.pocket.api" = "";
          "extensions.pocket.enabled" = false;
          "extensions.pocket.oAuthConsumerKey" = "";
          "extensions.pocket.showHome" = false;
          "extensions.pocket.site" = "";
          "general.smoothScroll" = true;
          "general.useragent.locale" = "en-GB";
          "gnomeTheme.normalWidthTabs" = true;
          "gnomeTheme.tabsAsHeaderbar" = true;
          "network.allow-experiments" = false;
          "policies.PasswordManagerEnabled" = true;
          "privacy.donottrackheader.enabled" = true;
          "privacy.partition.network_state.ocsp_cache" = true;
          "privacy.resistFingerprinting" = false;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "signon.rememberSignons" = false;
          "svg.content-properties.content.enabled" = true;
          "svg.context-properties.content.enabled" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "webgl.disabled" = true;
        };

        extraConfig = ''
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("full-screen-api.ignore-widgets", true);
          user_pref("media.ffmpeg.vaapi.enabled", true);
          user_pref("media.rdd-vpx.enabled", true);
        '';

        search = {
          force = true;
          default = "Google";
          engines = {
            "NixOS Options" = {
              urls = [{
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "type";
                    value = "options";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@no" ];
            };

            "NixOS Wiki" = {
              urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@nw" ];
            };

            "Nix Home Options" = {
              urls = [{
                template = "https://mipmip.github.io/home-manager-option-search";
                params = [
                  {
                    name = "type";
                    value = "options";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nh" ];
            };

            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "Nix Reference Manual" = {
              urls = [{ template = "https://nixos.org/manual/nix/stable/?search={searchTerms}"; }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@nm" ];
            };

            "OpenWRT Packages" = {
              urls = [{ template = "https://openwrt.org/packages/pkgdata/{searchTerms}"; }];
              iconUpdateURL = "https://openwrt.org/_media/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@ow" ];
            };

            "OpenWRT Wiki" = {
              urls = [{ template = "https://openwrt.org/de/start?do=search&q={searchTerms}"; }];
              iconUpdateURL = "https://openwrt.org/_media/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@ow" ];
            };

            "Zephyr Documentation" = {
              urls = [{ template = "https://docs.zephyrproject.org/latest/search.html?q={searchTerms}"; }];
              iconUpdateURL = "https://zephyrproject.org/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@zd" ];
            };

            "Zephyr Config" = {
              urls = [{
                template = "https://docs.zephyrproject.org/latest/kconfig.html?type=kconfig&query={searchTerms}";
              }];
              iconUpdateURL = "https://zephyrproject.org/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@zc" ];
            };

            "Docker Image" = {
              urls = [{ template = "https://hub.docker.com/search?q={searchTerms}"; }];
              iconUpdateURL = "https://hub.docker.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@di" ];
            };

            "Python Package" = {
              urls = [{ template = "https://pypi.org/search/?q={searchTerms}"; }];
              iconUpdateURL = "https://pypi.org/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@pip" ];
            };

            "Rust Crates" = {
              urls = [{ template = "https://crates.io/search?q={searchTerms}"; }];
              iconUpdateURL = "https://www.rust-lang.org/static/images/favicon-32x32.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@rc" ];
            };

            "Rust Book" = {
              urls = [{ template = "https://doc.rust-lang.org/beta/book/index.html?search={searchTerms}"; }];
              iconUpdateURL = "https://www.rust-lang.org/static/images/favicon-32x32.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@rb" ];
            };
          };
        };

        # extensions = with firefox-addons.packages; [
        #   block-origin
        #   bitwarden
        #   gopass-bridge
        #   react-devtools
        #   I-still-dont-care-about-cookies
        #   # dnssec
        #   # kde_connect
        #   ponsorblock
        #   arkreader
        #   ridactyl
        #   outube-shorts-block
        # ];
      };
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/xhtml+xml" = "firefox.desktop";
      "text/html" = "firefox.desktop";
      "text/xml" = "firefox.desktop";
      "x-scheme-handler/ftp" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  home.sessionVariables.BROWSER = "${lib.getExe package}";
}
