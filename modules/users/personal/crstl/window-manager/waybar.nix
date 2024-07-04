{ pkgs, ... }:
{
  home.packages = with pkgs; [ font-awesome ];

  programs.waybar = {
    enable = true;

    # package = pkgs.waybar.override {pulseSupport = true;};

    systemd = {
      enable = true;
      target = "graphical-session.target";
    };

    # font-family: "${osConfig.stylix.fonts.monospace.name}";
    style = ''
      * {
        font-size: 14px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }
    '';

    settings = [
      {
        gtk-layer-shell = true;

        layer = "top";
        height = 30;

        tray = {
          icon-size = 20;
          spacing = 10;
        };

        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "sway/scratchpad"
          "sway/window"
        ];

        modules-center = [
          "custom/launcher"
          "clock"
          "custom/lock"
          "custom/power-menu"
          "wireplumber"
        ];

        modules-right = [
          "mpd"
          "network"
          "battery"
          "backlight"
          "cpu"
          "memory"
          "disk"
          "temperature"
          "tray"
        ];

        "custom/launcher" = {
          format = " ❄ ";
          on-click = "${pkgs.rofi}/bin/rofi -show drun &";
        };

        "custom/lock" = {
          format = "  ";
          on-click = "${pkgs.swaylock}/bin/swaylock";
          tooltip = false;
        };

        "custom/power-menu" = {
          format = " ⏻  ";
          on-click = "${pkgs.systemd}/bin/loginctl terminate-user $USER";
        };

        clock = {
          format = "{:%d.%m.%Y | %H:%M}";
          tooltip-format = "{calendar}";
          on-click = "${pkgs.gnome.gnome-calendar}/bin/gnome-calendar";
        };

        battery = {
          format = " {icon} {capacity} %";
          format-alt = "{icon} {time}";
          format-charging = " {capacity} %";
          format-discharging = "{icon} {capacity} %";
          format-plugged = " {capacity} %";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          interval = 10;
          states = {
            good = 80;
            warning = 20;
            critical = 10;
          };
          tooltip = true;
          on-click = "${pkgs.gnome.gnome-power-manager}/bin/gnome-power-manager";
        };

        cpu = {
          format = " {usage} %";
          states = {
            warning = 70;
            critical = 90;
          };
          tooltip = true;
          interval = 1;
        };

        temperature = {
          format = " {temperatureC} °C";
        };

        memory = {
          format = " {percentage} %";
          tooltip-format = "{percentage}% used of {total} GB";
          states = {
            warning = 70;
            critical = 90;
          };
          tooltip = true;
          interval = 1;
        };

        disk = {
          format = "󰋊 {percentage_free} %";
          path = "/home";
          states = {
            warning = 70;
            critical = 90;
          };
          interval = 1;
          tooltip = true;
          tooltip-format = "{percentage_free} % are {free} of {total} GB";
          on-click = "${pkgs.gnome.gnome-disk-utility}/bin/gnome.gnome-disk-utility";
        };

        network = {
          format-alt = "{ipaddr}/{cidr}";
          format-disconnected = "⚠ Disconnected";
          format-ethernet = " {ifname}: {ipaddr}/{cidr}";
          format-linked = " {ifname} (No IP)";
          format-wifi = "  {essid} ({signalStrength} %)";
          on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
          tooltip = true;
          interval = 1;
        };

        pulseaudio = {
          format = " {icon} {volume} %";
          format-bluetooth = " {icon} {volume} %";
          format-bluetooth-muted = " {icon}";
          format-muted = " {icon}";
          format-source = " {volume} %";
          format-source-muted = " {icon}";
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          on-scroll-up = "${pkgs.ponymix}/bin/ponymix increase 1";
          on-scroll-down = "${pkgs.ponymix}/bin/ponymix decrease 1";
        };

        wireplumber = {
          format = " {icon} {volume} %";
          format-muted = " {icon}";
          format-source = " {volume} %";
          format-source-muted = " {icon}";
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          on-click-right = "${pkgs.helvum}/bin/helvum";
          on-scroll-up = "${pkgs.ponymix}/bin/ponymix increase 1";
          on-scroll-down = "${pkgs.ponymix}/bin/ponymix decrease 1";
        };

        mpd = {
          format-icons = [ "🎜" ];
          on-click = "${pkgs.cantata}/bin/cantata";
        };

        backlight = {
          format = "{icon} {percent} %";
          format-icons = [
            ""
            ""
          ];
          on-scroll-up = "${pkgs.brillo}/bin/brillo -e -A 0.5";
          on-scroll-down = "${pkgs.brillo}/bin/brillo -e -U 0.5";
          device = "intel_backlight";
        };

        "wlr/workspaces" = {
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            active = " 󰮯";
            default = "";
          };
          on-click = "activate";
        };
      }
    ];
  };
}
