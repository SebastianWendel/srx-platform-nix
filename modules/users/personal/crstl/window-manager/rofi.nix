{ lib
, pkgs
, config
, ...
}:
let
  # https://github.com/adi1090x/rofi
  style = "4";
  type = "2";
  color = "onedark";

  rofi-themes-adi1090x = pkgs.stdenv.mkDerivation {
    name = "rofi-themes-adi1090x";
    src = pkgs.fetchFromGitHub {
      owner = "adi1090x";
      repo = "rofi";
      rev = "ef71554d8b7097cbce1953f56d2d06f536a5826f";
      sha256 = "sha256-RePXizq3I7+u1aJMswOhotIqTVdPhaAGZQqn51lg2jY=";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  theme = "adi1090x-${style}-${type}-${color}";
in
{
  home.file = {
    "${config.xdg.configHome}/rofi/themes/${theme}.rasi" = {
      source = "${rofi-themes-adi1090x}/files/launchers/type-${type}/style-${style}.rasi";
    };
    "${config.xdg.configHome}/rofi/themes/shared/colors.rasi" = {
      source = "${rofi-themes-adi1090x}/files/launchers/type-${type}/shared/colors.rasi";
    };
    "${config.xdg.configHome}/rofi/themes/shared/fonts.rasi" = {
      source = "${rofi-themes-adi1090x}/files/launchers/type-${type}/shared/fonts.rasi";
    };
    "${config.xdg.configHome}/rofi/colors/${color}.rasi" = {
      source = "${rofi-themes-adi1090x}/files/colors/${color}.rasi";
    };
  };


  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = lib.mkForce theme;
    extraConfig = {
      monitor = -1;
      # font = osConfig.stylix.fonts.monospace.name;
      modi = "window,drun,run,ssh";
    };
  };
}
