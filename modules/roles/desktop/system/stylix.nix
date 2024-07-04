{ lib, pkgs, inputs, ... }:
{
  imports = with inputs; [
    stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;

    base16Scheme = "${inputs.base16-schemes}/material-palenight.yaml";

    image = pkgs.fetchurl {
      url = "https://media.githubusercontent.com/media/lovesegfault/nix-config/bda48ceaf8112a8b3a50da782bf2e65a2b5c4708/users/bemeurer/assets/walls/plants-00.jpg";
      hash = "sha256-n8EQgzKEOIG6Qq7og7CNqMMFliWM5vfi2zNILdpmUfI=";
    };

    autoEnable = true;
    polarity = lib.mkDefault "dark";

    cursor = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };

    fonts = lib.mkDefault {
      serif = {
        name = lib.mkDefault "DejaVu Serif";
        package = lib.mkDefault pkgs.dejavu_fonts;
      };

      sansSerif = {
        name = lib.mkDefault "DejaVu Sans";
        package = lib.mkDefault pkgs.dejavu_fonts;
      };

      monospace = {
        name = lib.mkDefault "DejaVu Sans Mono";
        package = lib.mkDefault pkgs.dejavu_fonts;
      };

      emoji = {
        name = lib.mkDefault "Twitter Color Emoji";
        package = lib.mkDefault pkgs.twitter-color-emoji;
      };
    };
  };
}
