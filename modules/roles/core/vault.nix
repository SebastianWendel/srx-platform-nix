{ lib, pkgs, config, ... }:
{
  environment = {
    systemPackages = [ pkgs.vault ];
    variables.VAULT_ADDR = lib.mkDefault "https://vault.vpn.srx.dev:5800";
  };

  vault-secrets = {
    vaultPrefix = "kv/system/${config.networking.hostName}";
    vaultAddress = config.environment.variables.VAULT_ADDR;
  };
}
