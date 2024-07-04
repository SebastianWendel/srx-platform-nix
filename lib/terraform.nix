{ self, lib, nixpkgs, ... }:
let
  inherit (lib) nameValuePair mapAttrs' genAttrs;
  inherit (builtins) toString toJSON;
  prefixMapper = mapAttrs' (n: nameValuePair "tf-${n}");
  defaultSubDir = "$(mktemp -d)";
in
{ system ? "x86_64-linux"
, pkgs ? nixpkgs.legacyPackages.${system}
, opentofu ? pkgs.opentofu
, tufoConfigAst ? null
, subdir ? defaultSubDir
, backend ? true
,
}:
rec {
  tufoConfig = pkgs.writeText "config.tf.json" (toJSON tufoConfigAst.config);
  tfsecConfig = pkgs.writeText "tfsec.json" (toJSON (import ../terranix/tfsec.nix));

  mkTofuApp =
    let
      defaultSubDir = subdir;
      defaultBackend = backend;
      defaultTFConfig = tufoConfig;
      vaultLogin =
        if tufoConfigAst.config ? "provider"."vault"."address" then
          ''
            export VAULT_ADDR='${tufoConfigAst.config."provider"."vault"."address"}'
            ${lib.getExe pkgs.vault} token lookup >/dev/null 2>&1 || ${lib.getExe pkgs.vault} login -method=oidc
          ''
        else
          "";
    in
    { tofuCommand
    , tufoConfig ? defaultTFConfig
    , subdir ? defaultSubDir
    , backend ? defaultBackend
    ,
    }:
    {
      type = "app";
      program = toString (pkgs.writers.writeBash tofuCommand ''
        pushd ${toString subdir} >/dev/null
        ${vaultLogin}
        if [[ -e config.tf.json ]]; then rm -f config.tf.json; fi
        cp ${tufoConfig} config.tf.json \
          && ${lib.getExe opentofu} init ${if backend then "-upgrade" else "-backend=false"} \
          && ${lib.getExe opentofu} ${toString tofuCommand} $@
        popd >/dev/null
      '');
    };

  tf-validate = {
    type = "app";
    program = toString (pkgs.writers.writeBash "tf-validate" ''
      pushd ${toString subdir} >/dev/null
      cp ${tufoConfig} config.tf.json \
      && ${lib.getExe opentofu} version \
      && ${lib.getExe opentofu} init -backend=false \
      && ${lib.getExe opentofu} validate \
      && ${lib.getExe opentofu} test \
      && ${pkgs.tfsec}/bin/tfsec --config-file ${tfsecConfig} \
      && ${pkgs.tflint}/bin/tflint
      popd >/dev/null
    '');
  };

  tf2nix = {
    type = "app";
    program = toString (pkgs.writers.writeBash "tf2nix" ''
      HCL=$(realpath $@)
      pushd ${toString subdir} >/dev/null
      ${lib.getExe pkgs.hcl2json} $HCL > output.json
      ${self.packages.${system}.json2nix}/bin/json2nix output.json
      popd >/dev/null
    '');
  };

  tf-state = pkgs.runCommand "tf-state" { } ''
    mkdir -p $out \
    && cp ${tufoConfig} config.tf.json \
    && cp ${tfsecConfig} tfsec.json  \
    && ${lib.getExe opentofu} init -backend=false \
    && ${lib.getExe opentofu} version -json > terraform.json \
    && ${lib.getExe opentofu} validate \
    && ${pkgs.tfsec}/bin/tfsec --config-file ${tfsecConfig} \
    && ${pkgs.tflint}/bin/tflint \
    && cp tfsec.json terraform.json .terraform.lock.hcl $out
  '';

  mkApps =
    commands: prefixMapper (genAttrs commands (tofuCommand: mkTofuApp { inherit tofuCommand; }));
}
