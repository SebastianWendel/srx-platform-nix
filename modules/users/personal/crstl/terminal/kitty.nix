{ lib, ... }:
{
  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    font = lib.mkForce {
      size = 14;
      name = "";
    };
    settings = {
      copy_on_select = "clipboard";
      scrollback_lines = 10000;
      update_check_interval = 0;
      enable_audio_bell = false;
    };
    keybindings = {
      "ctrl+plus" = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
      "ctrl+page_up" = "scroll_page_up";
      "ctrl+page_down" = "scroll_page_down";
    };
  };
}
