{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      cursor.style = "Beam";
      dynamic_padding = true;
      env.TERM = "xterm-256color";
      selection.save_to_clipboard = true;
      url.launcher.program = "${pkgs.mimeo}/bin/mimeo";
      colors.draw_bold_text_with_bright_colors = true;
    };
  };
}
