{ pkgs, config, ... }:
let
  host = "vault.vpn.srx.dev";
  ip = "10.80.0.4";
  ports = {
    api = 8200;
    cluster = 8201;
    stats = 8125;
  };
  schema = "https";
in
{
  environment = {
    systemPackages = [ pkgs.vault ];
    variables.VAULT_ADDR = "${schema}://${host}:${toString ports.api}";
  };

  services.vault = {
    enable = true;
    package = pkgs.vault-bin;
    storageBackend = "raft";
    address = "${ip}:${toString ports.api}";
    tlsCertFile = "${config.security.acme.certs.${host}.directory}/fullchain.pem";
    tlsKeyFile = "${config.security.acme.certs.${host}.directory}/key.pem";
    listenerExtraConfig = ''
      tls_min_version = "tls12"
    '';
    extraConfig = ''
      ui = true
      api_addr = "${schema}://${host}:${toString ports.api}"
      cluster_addr = "${schema}://${host}:${toString ports.cluster}"
    '';
    # extraSettingsPaths = [
    #   (pkgs.writeTextDir "nomad.hcl" (builtins.readFile ./policies/nomad.hcl))
    # ];
    # telemetryConfig = ''
    #   statsite_address = "${host}:${toString ports.stats}"
    # '';
  };

  security.acme.certs."${host}" = {
    domain = "${host}";
    group = "vault";
    reloadServices = [ "vault.service" ];
  };
}
