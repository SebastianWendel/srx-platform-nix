{ pkgs, ... }:
{
  home.packages = with pkgs; [
    swayr # A window switcher (and more) for sway

    wdisplays # A graphical application for configuring displays in Wayland compositors

    bemenu # wayland clone of dmenu
    mako # notification system developed by swaywm maintainer
    #wpaperd # Minimal wallpaper daemon for Wayland
    oguri # A very nice animated wallpaper daemon for Wayland compositors

    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    clipman # A simple clipboard manager for Wayland
    xclip # Tool to access the X clipboard from a console application
    xsel # Command-line program for getting and setting the contents of the X selection

    grim # screenshot functionality
    slurp # screenshot functionality

    brightnessctl # This program allows you read and control device brightness
    playerctl # ommand-line utility and library for controlling media players that implement MPRIS

    wev
  ];

  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    wrapperFeatures.gtk = true;
    swaynag.enable = true;

    systemd = {
      enable = true;
      xdgAutostart = true;
    };

    config = rec {
      bars = [ ];
      assigns = { };

      keybindings = {
        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+a" = "focus parent";
        "${modifier}+d" = menu;
        "${modifier}+e" = "exec ${pkgs.swaynag-battery}/bin/swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+l" = "exec ${pkgs.swaylock}/bin/swaylock";
        "${modifier}+r" = "mode resize";
        "${modifier}+y" = "floating disable";
        "${modifier}+x" = "floating enable";
        "${modifier}+s" = "layout stacking";
        "${modifier}+u" = "layout toggle split";
        "${modifier}+v" = "splitv";
        "${modifier}+h" = "splith";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+Left" = "focus left";
        "${modifier}+Right" = "focus right";
        "${modifier}+Up" = "focus up";
        "${modifier}+Down" = "focus down";
        "${modifier}+minus" = "scratchpad show";
        "${modifier}+space" = "focus mode_toggle";
        "${modifier}+Return" = terminal;
        "${modifier}+Print" = "exec ${pkgs.grim}/bin/grim ~/screenshot_$(date +%Y%m%d_%H%M%S).png";
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Right" = "move right";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+Shift+r" = "reload";
        "${modifier}+Shift+s" = "exec ${pkgs.systemd}/bin/systemctl suspend";

        "Ctrl+${modifier}+Left " = "workspace prev";
        "Ctrl+${modifier}+Right" = "workspace next";

        "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudioFull}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudioFull}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioMute" = "exec ${pkgs.pulseaudioFull}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";

        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";

        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";

        "XF86AudioMicMute" = "exec ${pkgs.ponymix}/bin/ponymix -t source toggle";

        "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
      };

      modifier = "Mod4";
      menu = "exec ${pkgs.rofi}/bin/rofi -show drun";
      terminal = "exec ${pkgs.kitty}/bin/kitty";
      keycodebindings = { };

      up = "e";
      down = "n";
      left = "h";
      right = "i";

      window = {
        border = 5;
        commands = [
          # swaymsg -t get_tree
          {
            criteria.app_id = "VirtualBox Machine";
            command = "floating enable";
          }
          {
            criteria.app_id = "io.elementary.calendar";
            command = "floating enable";
          }
          {
            criteria.app_id = "OpenSnitch*";
            command = "floating enable";
          }
          {
            criteria.app_id = "io.elementary.appcenter";
            command = "floating enable";
          }
          {
            criteria.app_id = "io.elementary.calculator";
            command = "floating enable";
          }
          {
            criteria.app_id = "io.elementary.files";
            command = "floating enable";
          }
          {
            criteria.app_id = "io.elementary.photos";
            command = "floating enable";
          }
          {
            criteria.app_id = "io.elementary.screenshot";
            command = "floating enable";
          }
          {
            criteria.app_id = "io.elementary.switchboard";
            command = "floating enable";
          }
          {
            criteria.app_id = "evince";
            command = "floating enable";
          }
          {
            criteria.app_id = "file-roller";
            command = "floating enable";
          }
          {
            criteria.app_id = ".blueman-manager-wrapped";
            command = "floating enable";
          }
          {
            criteria.app_id = "Alacritty";
            command = "opacity set 0.9";
          }
          {
            criteria.app_id = "Blueman-manager";
            command = "floating enable";
          }
          {
            criteria.app_id = "Bluetooth-wizard";
            command = "floating enable";
          }
          {
            criteria.app_id = "cantata";
            command = "floating enable";
          }
          {
            criteria.app_id = "com.nextcloud.desktopclient.nextcloud";
            command = "floating enable";
          }
          {
            criteria.app_id = "Element";
            command = "floating enable";
          }
          {
            criteria.app_id = "Evince";
            command = "floating enable";
          }
          {
            criteria.app_id = "Evolution-alarm-notify";
            command = "floating enable";
          }
          {
            criteria.app_id = "Evolution";
            command = "floating enable";
          }
          {
            criteria.app_id = "Fluffychat";
            command = "floating enable";
          }
          {
            criteria.app_id = "gnome-calculator";
            command = "floating enable";
          }
          {
            criteria.app_id = "Jitsi";
            command = "floating enable";
          }
          {
            criteria.app_id = "MPlayer";
            command = "floating enable";
          }
          {
            criteria.app_id = "Nautilus";
            command = "floating enable";
          }
          {
            criteria.app_id = "nm-connection-editor";
            command = "floating enable";
          }
          {
            criteria.app_id = "org.kde.kdeconnect.app";
            command = "floating enable";
          }
          {
            criteria.app_id = "org.kde.kdeconnect.sms";
            command = "floating enable";
          }
          {
            criteria.app_id = "org.kde.kdeconnect-indicator";
            command = "floating enable";
          }
          {
            criteria.app_id = "org.kde.kdeconnect.handler";
            command = "floating enable";
          }
          {
            criteria.app_id = "pavucontrol";
            command = "floating enable";
          }
          {
            criteria.app_id = "Pgadmin3";
            command = "floating enable";
          }
          {
            criteria.app_id = "Qemu-system-x86_64";
            command = "floating enable";
          }
          {
            criteria.app_id = "qtpass";
            command = "floating enable";
          }
          {
            criteria.app_id = "Shotwell";
            command = "floating enable";
          }
          {
            criteria.app_id = "Simple-scan";
            command = "floating enable";
          }
          {
            criteria.app_id = "Simplescreenrecorder";
            command = "floating enable";
          }
          {
            criteria.app_id = "telegramdesktop";
            command = "floating enable";
          }
          {
            criteria.app_id = "Thunar";
            command = "floating enable";
          }
          {
            criteria.app_id = "transmission-gtk";
            command = "floating enable";
          }
          {
            criteria.app_id = "virt-manager";
            command = "floating enable";
          }
          {
            criteria.app_id = "Wireshark";
            command = "floating enable";
          }
          {
            criteria.app_id = "X2GoAgent";
            command = "floating enable";
          }
          {
            criteria.app_id = "x2goclient";
            command = "floating enable";
          }
          {
            criteria.app_id = "org.gnome.Hamster.GUI";
            command = "floating enable";
          }
          {
            criteria.class = "Signal";
            command = "floating enable";
          }
          {
            criteria.app_id = "org.gnome.Calendar";
            command = "floating enable";
          }
          {
            criteria.app_id = "org.pipewire.Helvum";
            command = "floating enable";
          }
          {
            criteria.app_id = "org.gnome.Software";
            command = "floating enable";
          }
        ];
        hideEdgeBorders = "none";
        titlebar = false;
      };

      workspaceLayout = "default";

      output = {
        "*" = {
          # bg = "/home/crstl/Pictures/mems/JOM Optical Switches-920.jpg fill";
        };
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "de";
        };
      };
    };

    # extraConfig = ''
    #   include /etc/sway/config.d/*

    #   exec ${pkgs.swayidle}/bin/swayidle -w \
    #   timeout 300 "swaylock -f" \
    #   timeout 300 'swaymsg "output * dpms off"' \
    #           resume 'swaymsg "output * dpms on"' \
    #   before-sleep "swaylock -f"
    # '';
  };
}
