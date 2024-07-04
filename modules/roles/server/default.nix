{ inputs, self, lib, hostType, config, ... }:
{
  imports = with inputs; [
    srvos.nixosModules.server
    self.nixosModules.roles-core
    self.nixosModules.services-monitoring
  ];

  age.secrets.acmeUpdate.file = ./acme.age;

  nix = lib.optionalAttrs (hostType == "nixos") {
    optimise.dates = [ "05:30" ];
  };

  programs.msmtp = {
    enable = true;
    setSendmail = lib.mkIf config.services.postfix.enable false;
    defaults.aliases = "/etc/aliases";
    accounts = {
      default = {
        auth = false;
        host = "mail.vpn.srx.dev";
        from = "no-reply@srx.digital";
      };
    };
  };

  environment.etc.aliases = {
    text = ''
      root: hostmaster@srx.digital
    '';
    mode = "0644";
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      keyType = "ec384";
      email = "echo8@srx.dev";
      dnsProvider = "rfc2136";
      credentialsFile = config.age.secrets.acmeUpdate.path;
      webroot = null;
    };
  };
}
