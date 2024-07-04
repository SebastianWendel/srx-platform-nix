{ lib, pkgs, config, ... }:
{
  age.secrets.crstlPassword.file = ./password.age;

  users = {
    groups.crstl.gid = config.users.users.crstl.uid;
    users.crstl = {
      uid = 1000;
      isNormalUser = true;
      description = "Sebastian Wendel";
      createHome = true;
      group = "crstl";
      extraGroups =
        [ "users" "wheel" "dialout" ]
        ++ lib.optionals config.hardware.i2c.enable [ "i2c" ]
        ++ lib.optionals config.networking.networkmanager.enable [ "networkmanager" ]
        ++ lib.optionals config.programs.sway.enable [ "input" "video" ]
        ++ lib.optionals config.programs.wireshark.enable [ "wireshark" ]
        ++ lib.optionals config.sound.enable [ "audio" ]
        ++ lib.optionals config.services.unbound.enable [ "unbound" ]
        ++ lib.optionals config.services.paperless.enable [ "paperless" ]
        ++ lib.optionals config.virtualisation.libvirtd.enable [ "libvirtd" "qemu-libvirtd" ]
        ++ lib.optionals config.virtualisation.docker.enable [ "docker" ]
        ++ lib.optionals config.virtualisation.podman.enable [ "podman" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwyxpc0pVB46j1k5VCSabvI4TUADvAabnxlE5+D5o2l"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB6vk3k1p6YMsGLFQ/xABLYK/VJicywkf1MJawnN7oXU"
      ];
      shell = lib.mkIf config.programs.zsh.enable pkgs.zsh;
      hashedPasswordFile = config.age.secrets.crstlPassword.path;
    };
  };

  nix.settings.trusted-users = [ "crstl" ];

  home-manager.users.crstl = {
    imports = [
      ./terminal/ssh.nix
      ./terminal/tmux.nix
      ./terminal/kitty.nix
      ./terminal/zsh.nix
      ./terminal/htop.nix
      ./terminal/nix-index.nix
      ./terminal/dircolors.nix
      ./terminal/bat.nix
      ./terminal/starship.nix
      ./terminal/lsd.nix
      ./terminal/ripgrep.nix
      ./editor/neovim.nix
    ] ++ lib.optionals config.services.xserver.enable [
      ./gpg
      ./terminal/git.nix
      ./terminal/imv.nix
      ./terminal/jq.nix
      ./terminal/lf.nix
      ./terminal/rbw.nix
      ./terminal/thefuck.nix
      ./terminal/yazi.nix
      ./terminal/zoxide.nix
      ./terminal/awscli.nix
      ./system/home-manager.nix
      ./system/gtk.nix
      ./system/qt.nix
      ./system/xdg.nix
      ./system/gammastep.nix
      ./system/kanshi.nix
      ./system/stylix.nix
      ./desktop-manager/dconf.nix
      ./desktop-manager/blueman-applet.nix
      ./desktop-manager/gnome-keyring.nix
      ./desktop-manager/kdeconnect.nix
      ./desktop-manager/nextcloud-client.nix
      ./window-manager/dunst.nix
      ./window-manager/rofi.nix
      ./window-manager/sway.nix
      ./window-manager/swayidle.nix
      ./window-manager/waybar.nix
      ./browser/firefox.nix
      ./browser/chromium.nix
      ./chat/default.nix
      ./editor/emacs.nix
      ./editor/helix.nix
      ./editor/vscodium.nix
      ./media/mpd.nix
      ./media/mpv.nix
      ./office/pass.nix
      ./packages.nix
      ./cad
    ];

    home = {
      username = config.users.users.crstl.name;
      stateVersion = "22.05";
      shellAliases = {
        x = "${pkgs.yt-dlp}/bin/yt-dlp";
        vip = "${pkgs.curl}/bin/curl -s https://am.i.mullvad.net/json | jq";
        mip = "${pkgs.dnsutils}/bin/dig +short myip.opendns.com @208.67.222.222 2>&1";
        tp = "${pkgs.libressl}/bin/nc termbin.com 9999";
      };
    };

    services.gammastep = {
      inherit (config.location) latitude longitude;
    };

    programs = {
      obs-studio.enable = lib.mkIf config.services.xserver.enable true;
      freetube.enable = lib.mkIf config.services.xserver.enable true;
    };
  };
}
