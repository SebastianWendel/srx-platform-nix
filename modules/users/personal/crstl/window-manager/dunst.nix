{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        markup = "yes";
        plain_text = "no";
        sort = "yes";
        indicate_hidden = "yes";
        alignment = "left";
        bounce_freq = 0;
        show_age_threshold = 1;
        word_wrap = "yes";
        ignore_newline = "no";
        stack_duplicates = "yes";
        hide_duplicates_count = "no";
        shrink = "no";
        idle_threshold = 0;
        transparency = 5;
        monitor = "keyboard";
        follow = "mouse";
        sticky_history = "yes";
        history_length = 15;
        show_indicators = "yes";
        line_height = 5;
        separator_height = 1;
        padding = 5;
        horizontal_padding = 5;
        startup_notification = true;
        icon_position = "right";
        max_icon_size = 80;
        frame_width = 3;
      };
      shortcuts = {
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        context = "mod4+u";
      };
      urgency_low = {
        timeout = 3;
      };
      urgency_normal = {
        timeout = 5;
      };
      urgency_critical = {
        timeout = 10;
      };
    };
  };
}
