{ inputs, ... }:
{
  imports = with inputs; [
    srvos.nixosModules.common
    srvos.nixosModules.mixins-terminfo
    srvos.nixosModules.mixins-trusted-nix-caches
    srvos.nixosModules.mixins-nix-experimental
    disko.nixosModules.disko
    home-manager.nixosModules.home-manager
    agenix.nixosModules.age
    impermanence.nixosModules.impermanence
    nix-index-database.nixosModules.nix-index
    vault-secrets.nixosModules.vault-secrets
    self.nixosModules.services-dns
    self.nixosModules.services-dns-knsupdate

    ./boot.nix
    ./swap.nix
    ./security.nix
    ./cve.nix
    ./users.nix
    ./locale.nix
    ./time.nix
    ./nix.nix
    ./fail2ban.nix
    ./dns.nix
    ./openssh.nix
    ./motd.nix
    ./pkgs.nix
    ./home-manager.nix
    ./tmux.nix
    ./zsh.nix
    ./editor.nix
    ./commands.nix
    ./vault.nix
  ];
}
