{
  imports = [
    ./prometheus.nix
    ./alertmanager.nix
    ./rules.nix
    ./check/apcupsd.nix
  ];
}
