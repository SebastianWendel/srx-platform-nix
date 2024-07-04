{ pkgs, ... }:
{
  # services.pass-secret-service.enable = true;

  programs.password-store = {
    enable = true;
    settings.PASSWORD_STORE_DIR = "$HOME/.password-store";
  };

  home.packages = with pkgs; [
    gopass
    gopass-jsonapi
    qtpass
  ];
}
