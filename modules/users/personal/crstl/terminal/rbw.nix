{ pkgs, ... }:
{
  programs.rbw = {
    enable = true;
    settings = {
      email = "swendel@srx.digital";
      base_url = "https://vault.srx.digital/";
      pinentry = pkgs.pinentry-gnome3;
      sync_interval = 600;
      lock_timeout = 21600;
    };
  };
}
