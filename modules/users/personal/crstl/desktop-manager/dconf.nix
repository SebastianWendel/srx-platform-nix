{
  dconf.settings = {
    "org/gnome/mutter" = {
      attach-modal-dialogs = false;
      dynamic-workspaces = true;
      edge-tiling = false;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = false;
      experimental-features = [ "scale-monitor-framebuffer" ];
    };

    "org/gnome/desktop/interface" = {
      clock-show-date = true;
      clock-show-seconds = false;
      clock-show-weekday = true;
      enable-animations = true;
      enable-hot-corners = true;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-im-module = "ibus";
      locate-pointer = false;
      show-battery-percentage = true;
      toolkit-accessibility = false;
    };

    "org/gnome/desktop/search-providers" = {
      disabled = [ "org.gnome.Eolie.desktop" ];
      enabled = [ "org.gnome.Weather.desktop" ];
      sort-order = [
        "org.gnome.Contacts.desktop"
        "org.gnome.Documents.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };

    "org/gnome/desktop/sound" = {
      allow-volume-above-100-percent = false;
      event-sounds = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      action-double-click-titlebar = "toggle-maximize";
      button-layout = "appmenu:close";
      workspace-names = [
        "Workspace 5"
        "Workspace 2"
        "Workspace 4"
        "Workspace 1"
        "Workspace 8"
        "Workspace 8"
        "Workspace 8"
        "Workspace 8"
        "Workspace 8"
      ];
    };

    "org/gnome/gnome-system-monitor" = {
      network-total-in-bits = false;
      show-dependencies = false;
      show-whose-processes = "user";
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = true;
      night-light-schedule-to = 20.0;
      night-light-temperature = "uint32 2883";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = true;
      power-button-action = "suspend";
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-timeout = 1200;
      sleep-inactive-battery-type = "suspend";
    };

    "org/gnome/shell/extensions/paperwm" = {
      disable-scratch-in-overview = true;
      override-hot-corner = false;
    };

    "org/gnome/shell/extensions/paperwm/keybindings" = {
      close-window = [ "<Super>x" ];
      move-down-workspace = [ "<Shift><Super>m" ];
      move-up-workspace = [ "<Shift><Super>n" ];
      new-window = [ "<super>Return" ];
      switch-down = [ "<Super>j" ];
      switch-down-workspace = [ "<Super>m" ];
      switch-left = [ "<Super>h" ];
      switch-right = [ "<Super>l" ];
      switch-up = [ "<Super>k" ];
      switch-up-workspace = [ "<Super>n" ];
      toggle-scratch = [ "<Shift><Super>Escape" ];
      toggle-scratch-layer = [ "<Super>Escape" ];
      toggle-scratch-window = [ ];
    };

    "org/gnome/system/location" = {
      enabled = true;
    };
  };
}
