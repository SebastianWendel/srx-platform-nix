{ lib, pkgs, ... }:
{
  fonts = {
    fontDir.enable = lib.mkDefault true;
    fontconfig.enable = lib.mkForce true;
    enableDefaultPackages = lib.mkDefault true;

    packages = with pkgs;[
      fira-code
      fira-code-symbols

      material-design-icons
      material-symbols

      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji

      roboto-mono
      source-code-pro

      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "Hack"
          "Meslo"
        ];
      })

      # srx ci fonts
      manrope
      martian-mono
      #literata
    ];
  };
}
