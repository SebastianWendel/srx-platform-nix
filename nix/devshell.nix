{ self, lib, inputs, ... }:
{
  imports = with inputs; [
    git-hooks.flakeModule
    treefmt-nix.flakeModule
    devenv.flakeModule
    devshell.flakeModule
    flake-root.flakeModule
  ];

  perSystem = { self', inputs', pkgs, config, ... }:
    {
      formatter = config.treefmt.build.wrapper;

      pre-commit = {
        inherit pkgs;
        check.enable = true;
        settings = {
          hooks = {
            treefmt.enable = true;
            nil.enable = true;
            statix.enable = true;
            deadnix.enable = true;
            shellcheck.enable = true;
          };
          excludes = [ "flake.lock" ];
        };
      };

      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          deadnix.enable = true;
          deadnix.no-lambda-pattern-names = true;
          nixpkgs-fmt.enable = true;
          shellcheck.enable = true;
          statix.enable = true;
        };
      };

      devShells = {
        default = pkgs.mkShell {
          name = "srx.nix.digital";
          inputsFrom = [
            config.flake-root.devShell
            self'.devShells.commands
            self'.devShells.nix
            self'.devShells.k8s
            self'.devShells.opentofu
          ];
          packages = with pkgs; [
            gitFull
            git-lfs
            treefmt
            act
            actionlint
            shellcheck
            bind
            knot-dns
            wireguard-tools
            ipcalc
            minio-client
          ];

          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };

        nix = pkgs.mkShell {
          packages = with pkgs; [
            (pkgs.vault-push-approle-envs self')
            (pkgs.vault-push-approles self')
            agenix
            deadnix
            nil
            nix-fast-build
            sops
            statix
            vault
          ];
        };

        k8s = pkgs.mkShell {
          packages = with pkgs; [
            k3d
            kubectl
            kubernetes-helm
          ];
        };
      };

      devshells.commands = {
        motd = ''
          $(echo -e "\n")
          {202}SRX Platform Development Environment{reset}
          $(type -p menu &>/dev/null && menu)
        '';

        commands = [
          {
            name = "reload";
            command = "direnv reload";
            help = "Reload the local environment.";
            category = "development";
          }
          {
            name = "fmt";
            command = "nix fmt";
            help = "Run reformating with nix flake.";
            category = "development";
          }
          {
            name = "generate";
            command = "${inputs'.nixos-generators.packages.nixos-generate}/bin/nixos-generate $@";
            help = "Generate NixOS configuration with nixos-generators.";
            category = "development";
          }
          {
            name = "health";
            command = "${lib.getExe pkgs.nix-health}";
            help = "Checking the health of your Nix setup.";
            category = "nix";
          }
          {
            name = "list";
            command = "nix flake show";
            help = "Run nix flake cheshow.";
            category = "nix";
          }
          {
            name = "check";
            command = "nix flake check";
            help = "Run nix flake check.";
            category = "nix";
          }
          {
            name = "build";
            command = "nix build";
            help = "Run nix flake build.";
            category = "nix";
          }
          {
            name = "run";
            command = "nix run .\#run-qemu-vm -- $@";
            help = "Run host build in a qemu vm.";
            category = "nix";
          }
          {
            name = "repl";
            command = "nix repl -f .";
            help = "Evaluate expressions interactive with Nix repl.";
            category = "nix";
          }
          {
            name = "inspect";
            command = "${lib.getExe pkgs.nix-inspect}";
            help = "Inspect NixOS config and Nix expressions.";
            category = "nix";
          }
          {
            name = "cve";
            command = "nix build && ${lib.getExe pkgs.vulnix} ./result";
            help = "Run NixOS security scanner with vulnix.";
            category = "security";
          }
          {
            name = "secrets";
            command = "${pkgs.trivy}/bin/trivy fs .";
            help = "All-in-one security scanner with trivy.";
            category = "security";
          }
          {
            name = "age";
            command = "${pkgs.agenix}/bin/agenix $@";
            help = "Manage NixOS secrets with agenix.";
            category = "operations";
          }
          {
            name = "infect";
            command = "${inputs'.nixos-anywhere.packages.nixos-anywhere}/bin/nixos-anywhere $@";
            help = "Install NixOS everywhere via ssh.";
            category = "operations";
          }
          {
            name = "deploy";
            command = "${pkgs.deploy-rs.deploy-rs}/bin/deploy $@";
            help = "Deploy NixOS remote machines with deploy-rs.";
            category = "operations";
          }
          {
            name = "show";
            command = "terranix --pkgs /run/current-system/nixpkgs terranix/default.nix";
            help = "Show terranix state.";
            category = "terraform";
          }
          {
            name = "validate";
            command = "nix run .\#tf-validate";
            help = "Run terraform validate.";
            category = "terraform";
          }
          {
            name = "apply";
            command = "nix run .\#tf-apply";
            help = "Run terraform apply.";
            category = "terraform";
          }
          {
            name = "destroy";
            command = "nix run .\#tf-destroy";
            help = "Run terraform destroy.";
            category = "terraform";
          }
          {
            name = "state";
            command = "nix run .\#tf-state -- $@";
            help = "Manage terraform state.";
            category = "terraform";
          }
        ];
      };

      apps = {
        run-qemu-vm = {
          type = "app";
          program = toString (pkgs.writers.writeBash "run-qemu-vm" ''
            if [[ ! -z "$@" ]]; then
              nixos-rebuild build-vm --flake .#$@
              export QEMU_NET_OPTS="hostfwd=tcp::2221-:22"
              ./result/bin/run-$@-vm
            else
              echo "Usage: "$0" <host>"
              exit 1
            fi
          '');
        };

        nix-upgrades = {
          type = "app";
          program = toString (pkgs.writers.writeBash "nix-upgrades" ''
            set -eou pipefail

            NORMAL="\033[0m"
            RED="\033[0;31m"
            YELLOW="\033[0;33m"
            GREEN="\033[0;32m"
            SKULL="💀"
            CHECK="✅"
            WARNING="⚠️"
            FIRE="🔥"
            MAG="🔍"

            echo
            echo -e "$YELLOW$MAG Scanning for upgradable hosts...$NORMAL"
            echo

            ${lib.concatMapStringsSep "\n" (host:
              let
                inherit (self.hosts.${host}) address;
              in lib.optionalString (address != null) ''
                echo -n -e "${host}: $RED"
                RUNNING=$(ssh "${address}" "readlink /run/current-system")
                if [ $? = 0 ] && [ -n "$RUNNING" ]; then
                  CURRENT=$(nix eval --raw ".#nixosConfigurations.${host}.config.system.build.toplevel" 2>/dev/null)
                  RUNNING_VER=$(basename $RUNNING|rev|cut -d - -f 1|rev)
                  RUNNING_DATE=$(echo $RUNNING_VER|cut -d . -f 3)
                  CURRENT_VER=$(basename $CURRENT|rev|cut -d - -f 1|rev)
                  CURRENT_DATE=$(echo $CURRENT_VER|cut -d . -f 3)

                  if [ "$RUNNING" = "$CURRENT" ]; then
                    echo -e "$GREEN$CHECK Current: $NORMAL $RUNNING_VER"
                  elif [ $RUNNING_DATE -gt $CURRENT_DATE ]; then
                    echo -e "$GREEN$FIRE Newer: $NORMAL $RUNNING_VER > $CURRENT_VER"
                  elif [ "$RUNNING_VER" = "$CURRENT_VER" ]; then
                    echo -e "$YELLOW$WARNING Modified: $NORMAL $RUNNING_VER"
                  elif [ -n "$RUNNING_VER" ]; then
                    echo -e "$RED$SKULL Outdated: $NORMAL $RUNNING_VER < $CURRENT_VER"
                  else
                    echo -e "$RED$SKULL Error: $NORMAL $RUNNING_VER"
                  fi
                else
                  echo -e "$RED$SKULL SSH Connection Failed$NORMAL"
                fi
                echo -n -e "$NORMAL"
              '') (builtins.attrNames self.nixosConfigurations)}
          '');
        };
      };
    };
}
