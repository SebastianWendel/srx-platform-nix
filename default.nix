{ system ? builtins.currentSystem, src ? ./. }:
let
  inherit (lock.nodes.flake-compat.locked) owner repo rev narHash;

  lock = builtins.fromJSON (builtins.readFile ./flake.lock);

  flake-compat = fetchTarball {
    url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
    sha256 = narHash;
  };

  flake = import flake-compat { inherit src system; };
in
flake.defaultNix
