let
  hosts = {
    dev-vm = mkHost {
      type = "nixos";
      address = "192.168.122.26";
      hostPlatform = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJg26fCklaaX7aakk8YKsBE1cvZmK7BbGRepnlljO0A";
      remoteBuild = false;
    };
    srxgp00 = mkHost {
      type = "nixos";
      address = "srxgp00.vpn.srx.dev";
      hostPlatform = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKTMIY7REnKImy/UZ5SBcFLVywHjNtJB+TkwfnI8oqR3";
      remoteBuild = false;
    };
    srxgp01 = mkHost {
      type = "nixos";
      address = "srxgp01.vpn.srx.dev";
      hostPlatform = "aarch64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP4z3JIB0cwLTHpek2yXvFiUIzBkQf39Y0XE3tG8/02U";
      remoteBuild = false;
    };
    srxgp02 = mkHost {
      type = "nixos";
      address = "srxgp02.vpn.srx.dev";
      hostPlatform = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILOatQqlVBjRGIK6Y95O73XOkvN6BOnn7xPTKA9olJYZ";
      remoteBuild = false;
    };
    srxk8s00 = mkHost {
      type = "nixos";
      address = "srxk8s00.vpn.srx.dev";
      hostPlatform = "aarch64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKnculMw+8hP3gix/K4OBqGqrx16Cs2ODxM0V52YXNrT";
      remoteBuild = false;
    };
    srxnas00 = mkHost {
      type = "nixos";
      address = "srxnas00.vpn.srx.dev";
      hostPlatform = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHiUYwPlTez18gwbhWC3sB6LoYmDPz0suTF5n3zEGBhg";
      remoteBuild = false;
    };
    srxnas01 = mkHost {
      type = "nixos";
      address = "srxnas01.vpn.srx.dev";
      hostPlatform = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDUTiU0WPTLF98yla0Mmit6eIfPpcrDKRemjM1VoHc9w";
      remoteBuild = false;
    };
    srxws00 = mkHost {
      type = "nixos";
      address = "srxws00.vpn.srx.dev";
      hostPlatform = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlG7m82O7W/Btp98ddipBiIvYkXAy1TP3kyRfYuL0aF";
      remoteBuild = false;
    };
    srxnb00 = mkHost {
      type = "nixos";
      address = "srxnb00.vpn.srx.dev";
      hostPlatform = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII+ylR/an6nDQR1CBlWjPnUGf+2JJ9S3APaERFiZ6exT";
      remoteBuild = false;
    };
    srxws01 = mkHost {
      type = "nixos";
      address = "srxws01.vpn.srx.dev";
      hostPlatform = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM54ABNX402t+q3hNKjJc1rhXLJckgCLlaDug4+7nfN2";
      remoteBuild = false;
    };
    srxtab00 = mkHost {
      type = "nixos";
      address = "srxtab00.vpn.srx.dev";
      hostPlatform = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJf8iY3QMWoJdYibBsTA9CZE+GQluhp/N+0Vxid7nSP";
      remoteBuild = false;
    };
    srxmc00 = mkHost {
      type = "nixos";
      address = "srxmc00.vpn.srx.dev";
      hostPlatform = "x86_64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGXv0QxmY2C44SvnV3HZd+wBhxc//ox8YhfDnh2L1k4f";
      remoteBuild = false;
    };
    srxfdm00 = mkHost {
      type = "nixos";
      address = "srxfdm00.vpn.srx.dev";
      hostPlatform = "aarch64-linux";
      pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG2Z5iETExjTSn+F1QFwSnyrn5UdSnkn6C+rIM7Dssei";
      remoteBuild = false;
    };
  };

  hasSuffix =
    suffix: content:
    let
      inherit (builtins) stringLength substring;
      lenContent = stringLength content;
      lenSuffix = stringLength suffix;
    in
    lenContent >= lenSuffix && substring (lenContent - lenSuffix) lenContent content == suffix;

  mkHost =
    { type
    , hostPlatform
    , address ? null
    , pubkey ? null
    , homeDirectory ? null
    , remoteBuild ? true
    , large ? false
    ,
    }:
    if type == "nixos" then
      assert address != null && pubkey != null;
      assert (hasSuffix "linux" hostPlatform);
      { inherit type hostPlatform address pubkey remoteBuild large; }
    else if type == "darwin" then
      assert pubkey != null;
      assert (hasSuffix "darwin" hostPlatform);
      { inherit type hostPlatform pubkey large; }
    else if type == "home-manager" then
      assert homeDirectory != null;
      { inherit type hostPlatform homeDirectory large; }
    else
      throw "unknown host type '${type}'";
in
{
  flake = {
    inherit hosts;
  };
}
