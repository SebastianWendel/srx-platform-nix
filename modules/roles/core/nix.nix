{ lib, pkgs, hostType, ... }:
{
  nix = {
    package = lib.mkForce pkgs.nixVersions.latest;
    settings = {
      accept-flake-config = true;
      auto-optimise-store = hostType == "nixos";
      sandbox = hostType == "nixos";
      build-users-group = "nixbld";
      system-features = [
        "benchmark"
        "big-parallel"
        "recursive-nix"
        "nixos-test"
        "kvm"
      ];
      allowed-users = [ "@wheel" ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = [
        "flakes"
        "auto-allocate-uids"
        "nix-command"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://nix-config.cachix.org"
        "https://arm.cachix.org/"
        "https://cuda-maintainers.cachix.org"
        "https://cache.nix.srx.digital"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-config.cachix.org-1:Vd6raEuldeIZpttVQfrUbLvXJHzzzkS0pezXCVVjDG4="
        "arm.cachix.org-1:5BZ2kjoL1q6nWhlnrbAl+G7ThY7+HaBRD9PZzqZkbnM="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "cache.nix.srx.digital-1:+sJ/hAmjuhTpRakfhkCj7i2LoqNyBgm+YItJUSAWWlg="
      ];
      cores = 0;
      max-jobs = "auto";
      connect-timeout = 5;
      http-connections = 0;
      flake-registry = "/etc/nix/registry.json";
    };
    distributedBuilds = true;
  }
  // lib.optionalAttrs (hostType == "nixos") {
    channel.enable = false;
    daemonCPUSchedPolicy = lib.mkDefault "batch";
    daemonIOSchedPriority = 5;
    nixPath = [ "nixpkgs=/run/current-system/nixpkgs" ];
    optimise.automatic = true;
  };

  system.extraSystemBuilderCmds = ''
    ln -sv ${pkgs.path} $out/nixpkgs
  '';
}
