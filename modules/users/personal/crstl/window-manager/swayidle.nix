{ pkgs, ... }:
{
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -efF";
      }
      {
        event = "after-resume";
        command = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
      }
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock -efF";
      }
    ];
    timeouts = [
      {
        timeout = 270;
        command = ''${pkgs.libnotify}/bin/notify-send -t 30000 -- "Screen will lock in 30 seconds"'';
      }
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -efF";
      }
      {
        timeout = 600;
        command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
        resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
      }
    ];
  };
}
