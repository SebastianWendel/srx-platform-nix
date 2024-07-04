{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libgnome-keyring
    nextcloud-client
  ];

  services.nextcloud-client.enable = true;
}
