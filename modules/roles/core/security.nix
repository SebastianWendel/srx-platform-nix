{ lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    apparmor-parser
    apparmor-profiles
  ];

  security = {
    protectKernelImage = lib.mkDefault true;

    sudo = {
      enable = true;
      wheelNeedsPassword = lib.mkForce false;
    };

    apparmor = {
      enable = true;
      packages = with pkgs; [
        apparmor-utils
        apparmor-profiles
      ];
    };

    pam = {
      enableEcryptfs = lib.mkDefault true;

      loginLimits = [
        { domain = "*"; type = "-"; item = "memlock"; value = "unlimited"; }
        { domain = "*"; type = "-"; item = "nofile"; value = "1048576"; }
        { domain = "*"; type = "-"; item = "nproc"; value = "unlimited"; }
      ];
    };

    tpm2 = {
      enable = true;
      pkcs11.enable = true;
    };

    dhparams.enable = lib.mkForce true;
  };
}
