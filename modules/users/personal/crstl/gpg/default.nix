{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    enableScDaemon = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  programs.gpg = {
    enable = true;
    settings = {
      default-key = "EECAAE75129CF8D1DE4771F471D71CBBEA1E76AD";
      keyserver = "hkps://keys.openpgp.org";
      keyserver-options = "no-honor-keyserver-url";
    };
  };
}
