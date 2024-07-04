{ inputs, lib, ... }:
let
  importLocalOverlay = file:
    lib.composeExtensions
      (_: _: { __inputs = inputs; })
      (import (../overlays + "/${file}"));

  localOverlays =
    lib.mapAttrs'
      (f: _: lib.nameValuePair
        (lib.removeSuffix ".nix" f)
        (importLocalOverlay f)
      )
      (builtins.readDir ../overlays);

in
{
  flake.overlays = {
    inherit localOverlays;

    default = lib.composeManyExtensions [
      inputs.agenix.overlays.default
      inputs.deploy-rs.overlays.default
      inputs.nixvim.overlays.default
      inputs.nur.overlay
      inputs.vault-secrets.overlays.default

      (final: _prev: {
        inherit (inputs.nix-fast-build.packages.${final.stdenv.hostPlatform.system}) nix-fast-build;
        inherit (inputs.srx-digital-website.packages.${final.stdenv.hostPlatform.system}) srx-digital;
        inherit (inputs.nix-hamburg-website.packages.${final.stdenv.hostPlatform.system}) nix-hamburg;
        inherit (inputs.cq-flake.packages.${final.stdenv.hostPlatform.system}) cq-editor;
      })
    ];
  };
}
