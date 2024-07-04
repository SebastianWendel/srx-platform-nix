{ lib, pkgs, ... }:
let
  getRuleFiles = lib.mapAttrs'
    (
      f: _: lib.nameValuePair (lib.removeSuffix ".nix" f) (import (./rules + "/${f}"))
    )
    (builtins.readDir ./rules);

  formatRules =
    rules:
    (lib.mapAttrsToList (
      name: opts: {
        alert = name;
        expr = opts.condition;
        for = opts.time or "1m";
        labels = opts.labels or { };
        annotations.description = opts.description;
      }
    ))
      rules;

  writeRuleFile =
    name: value:
    (pkgs.writeText "prometheus-rules-${name}.yaml" (
      builtins.toJSON {
        groups = [
          {
            inherit name;
            rules = formatRules value;
          }
        ];
      }
    ));
in
{
  services.prometheus.ruleFiles = lib.attrsets.mapAttrsToList writeRuleFile getRuleFiles;
}
