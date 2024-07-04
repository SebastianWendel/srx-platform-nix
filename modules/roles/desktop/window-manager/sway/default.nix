{ pkgs, ... }:
{
  programs.sway = {
    enable = true;

    wrapperFeatures = {
      gtk = true;
      base = true;
    };

    extraSessionCommands = ''
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway
      export XDG_CURRENT_DESKTOP=sway
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND = "1";
      export NIXOS_OZONE_WL = "1";
    '';

    extraPackages = with pkgs; [
      xwayland
      swayidle
      swaylock
      swayws
      swayr
      slurp
      wl-clipboard
      wf-recorder
    ];
  };
}
