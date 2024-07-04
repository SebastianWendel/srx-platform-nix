{ pkgs, lib, ... }:
let
  mkZshPlugin =
    { pkg
    , file ? "${pkg.pname}.plugin.zsh"
    ,
    }:
    {
      name = pkg.pname;
      inherit (pkg) src;
      inherit file;
    };
in
{
  home.packages = with pkgs; [ thefuck ];

  programs.zsh = {
    enable = lib.mkForce true;
    autocd = true;

    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;

    plugins = with pkgs; [
      (mkZshPlugin { pkg = zsh-z; })
      (mkZshPlugin { pkg = zsh-abbr; })
      (mkZshPlugin { pkg = zsh-fzf-tab; })
      (mkZshPlugin { pkg = zsh-autoenv; })
      (mkZshPlugin { pkg = zsh-autopair; })
      (mkZshPlugin { pkg = zsh-nix-shell; })
      (mkZshPlugin { pkg = zsh-completions; })
      (mkZshPlugin { pkg = zsh-you-should-use; })
      (mkZshPlugin { pkg = zsh-autosuggestions; })
      (mkZshPlugin { pkg = zsh-navigation-tools; })
      (mkZshPlugin { pkg = zsh-fzf-history-search; })
      (mkZshPlugin { pkg = zsh-fast-syntax-highlighting; })
      (mkZshPlugin { pkg = zsh-history-substring-search; })
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "argocd"
        "direnv"
        "git"
        "golang"
        "helm"
        "httpie"
        "kubectl"
        "nomad"
        "pass"
        "podman"
        "ssh-agent"
        "systemd"
        "terraform"
        "vault"
      ];
    };

    history = {
      extended = true;
      ignoreDups = true;
      expireDuplicatesFirst = true;
    };
  };
}
