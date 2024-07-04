{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  imports = [ inputs.microvm.nixosModules.host ];

  config = {
    networking = {
      useNetworkd = lib.mkDefault true;

      nat = {
        enable = lib.mkDefault true;
        enableIPv6 = lib.mkDefault true;
        internalInterfaces = [ "microvm" ];
      };
    };

    systemd.network = {
      enable = true;

      netdevs."10-microvm".netdevConfig = {
        Kind = "bridge";
        Name = "microvm";
      };

      networks = {
        "10-microvm" = {
          matchConfig.Name = "microvm";
          networkConfig = {
            DHCPServer = lib.mkDefault true;
            IPv6SendRA = lib.mkDefault true;
          };
        };

        "11-microvm" = {
          matchConfig.Name = "vm-*";
          networkConfig.Bridge = "microvm";
        };
      };
    };
  };
}
