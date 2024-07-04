{ lib, ... }:
{
  console.keyMap = lib.mkDefault "de";

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    supportedLocales = lib.mkDefault [
      "en_US.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
    ];
    extraLocaleSettings = lib.mkDefault {
      LANG = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
    };
  };

  services.xserver.xkb = {
    layout = lib.mkDefault "de";
    options = lib.mkDefault "eurosign:e";
  };
}
