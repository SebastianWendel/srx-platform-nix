
# srx digital - nix platform repository

<img src="https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake-colours.svg" alt="Nix Flake Logo" style="float: right; width: 150px; height: auto;">

This is the platform repository of [srx.digital](https://srx.digital), a Nix development and operations company based in Hamburg, Germany.

[NixOS](https://nixos.org/) is a Linux distribution built on the [Nix package manager](https://nixos.wiki/wiki/Nix_package_manager), utilizing declarative configuration to ensure reproducible and reliable system setups.

This repository contains opinionated configurations for deploying NixOS systems and cloud infrastructures with [Terraform](https://www.terraform.io/), written in pure [Nix](https://nixos.org/learn) expressions. It offers developers and DevOps engineers an insight into the potential of Nix.

## 📜 Principles of Operation

This repository uses 100% Infrastructure as Code and does not need to be configured manually. All services are monitored and backed up. Common services are modularized for reuse, but the separation of custom configurations is in progress. Reusable components will be moved to a separate Flake module in the near future.

📌 **Note**

> Some customer-specific configurations are stored in a private Git repository and imported as the `srx-nixos-shadow` flake to protect customer infrastructure. Due to its private nature, some tasks may fail and should be commented out. Generally, all expressions should evaluate without issues.

## 🛠️ Components

- [flake-parts](https://github.com/hercules-ci/flake-parts): Simplify Nix Flakes with the module system.
- [git-hooks](https://github.com/cachix/git-hooks.nix): Seamless integration of git hooks with Nix.
- [agenix](https://github.com/ryantm/agenix): Encrypted secrets for NixOS and Home Manager.
- [deploy-rs](https://github.com/serokell/deploy-rs): A multi-profile Nix-flake deployment tool.
- [nixos-anywhere](https://github.com/nix-community/nixos-anywhere): Install NixOS anywhere via SSH.
- [disko](https://github.com/nix-community/disko): Declarative disk partitioning.
- [srvos](https://github.com/nix-community/srvos): NixOS profiles for servers.
- [Tang & Clevis](https://fosdem.org/2024/schedule/event/fosdem-2024-3044-clevis-tang-unattended-boot-of-an-encrypted-nixos-system/): An automated encryption framework for full disk encryption.
- [Lanzaboote](https://github.com/nix-community/lanzaboote): Secure Boot for NixOS.
- [home-manager](https://github.com/nix-community/home-manager): Manage user environments using Nix.
- [terranix](https://terranix.org/): Create [OpenTofu](https://opentofu.org/) JSON files the NixOS way.
- [kubenix](https://kubenix.org/): Kubernetes management with Nix.
- [stylix](https://stylix.danth.me/): Apply consistent color schemes, fonts, and wallpapers.
- [hydra](https://github.com/NixOS/hydra): The Nix-based continuous build system.

## 📁 Repository layout

```txt
├── hosts         - NixOS server configurations
├── lib           - Reusable Nix libraries
├── modules       - Reusable NixOS modules
├── nix           - Flake-parts modules
├── overlays      - Nix package overlays
├── secrets.nix   - Age-encrypted secrets
├── terranix      - Terraform Nix expressions
├── default.nix   - Legacy support with flake-compat
├── flake.lock    - Lock file for version pinning
└── flake.nix     - Flakes configuration
```

## 🚀 Getting started

### 📋 Prerequisites

Before proceeding, ensure the following tools are installed:

- [Git](https://git-scm.com/): For cloning and managing the repository.
- [direnv](https://direnv.net/): To automatically enter Nix environments.
- [Nix package manager](https://nixos.org/download#download-nix): Essential for Nix or NixOS operations.

### 🛠️ Commands

Run `menu` or `nix flake show` to view all commands and aliases provided by the devshell, as defined in [nix/devshell.nix](nix/devshell.nix).

### 🖥️ NixOS

#### 🔐 Secrets

Secrets are encrypted using [agenix](https://github.com/ryantm/agenix). To add secret files and new hosts with their SSH public key, edit [nix/hosts.nix](nix/hosts.nix).

- `agenix --edit` edits FILE using $EDITOR
- `agenix --decrypt` decrypts FILE to STDOUT
- `agenix --rekey` re-encrypts all secrets with specified recipients

#### 🏭 Development

To begin, run `nix develop` in the source tree to enter the development shell, or use [direnv](https://direnv.net/) for automatic entry. Check [flake.nix](flake.nix) or run `nix flake show` to view the flake definition. Server definitions are described in the [hosts](hosts) folder. Module definitions are located in the [nix/modules.nix](nix/modules.nix) and [modules](modules) folders.

#### 🧪 local Testing

To build and run a local [QEMU](https://www.qemu.org/) VM, use the following steps:

1. Build the system with:

   ```sh
   nixos-rebuild build-vm --flake .#dev-vm
   ```

2. Configure the network settings:

   ```sh
   export QEMU_NET_OPTS="hostfwd=tcp::2221-:22"
   ```

3. Start the VM:

   ```sh
   result/bin/run-dev-vm-vm
   ```

4. Access the VM via SSH:

   ```sh
   ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@localhost -p 2221
   ```

#### 🎯 Deployment

[deploy-rs](https://github.com/serokell/deploy-rs) is a straightforward deployment tool for NixOS systems. It is configured in [nix/deploy.nix](nix/deploy.nix), where you can adjust `autoRollback` or `magicRollback` options.

To deploy, run:

```sh
deploy .#dev-vm
```

For more information on usage, refer to the [`deploy --help`](https://github.com/serokell/deploy-rs) documentation.

### 🪐 Terraform

This project uses [OpenTofu](https://opentofu.org/) and [terranix](https://terranix.org/) for creating Terraform JSON files the Nix way.

#### 🔗 Environment Variables

Create a local and private [.envrc.local](.envrc.local) file to authenticate with remote services during local development and operations.

- **AWS_ACCESS_KEY_ID** and **AWS_SECRET_ACCESS_KEY**: Required for accessing S3 services, crucial for state management. Refer to [Terraform S3 State](https://developer.hashicorp.com/terraform/language/settings/backends/s3) for more details.
- **GITHUB_TOKEN**: Authenticates against GitHub for repository access and API interactions. [Details](https://docs.github.com/en/actions/security-guides/automatic-token-authentication).
- **HYDRA_HOST**, **HYDRA_USERNAME**, **HYDRA_PASSWORD**: Configures and authenticates with a Hydra server for CI/CD operations. [Hydra provider documentation](https://github.com/DeterminateSystems/terraform-provider-hydra).
- **GRAFANA_AUTH**: Enables Grafana server authentication for dashboard access and API use. [Grafana provider usage](https://registry.terraform.io/providers/grafana/grafana/).
- **MINIO_ENABLE_HTTPS**, **MINIO_ENDPOINT**, **MINIO_ROOT_USER**, **MINIO_ROOT_PASSWORD**: Sets up MinIO services, ensuring secure and authenticated connections. [MinIO provider usage](https://registry.terraform.io/providers/aminueza/minio).

#### 📦 State Management

The [Terraform state](https://developer.hashicorp.com/terraform/language/state) is stored outside the repository in an S3 Bucket, configured in [terraform.nix](terranix/minio/terraform.nix) and hosted by [minio.nix](hosts/srxgp00/services/minio/default.nix).

#### 🔧 Configuration

Terraform version and providers are pinned and configured in [nix/terranix.nix](nix/terranix.nix). Terraform resources are declared in the [terranix](terranix) folder.

#### 🕹️ Terraform Commands

- `nix run .#tf-init` - Initializes the working directory.
- `nix run .#tf-state` - Performs basic state modifications.
- `nix run .#tf-import` - Import existing infrastructure resources.
- `nix run .#tf-validate` - Validates using [tfsec](https://github.com/aquasecurity/tfsec), configured in [tfsec.nix](terranix/tfsec.nix).
- `nix run .#tf-plan` - Creates the execution plan.
- `nix run .#tf-apply` - Executes the actions proposed in the plan.
- `nix run .#tf-destroy` - Destroys all remote objects.

#### 🧰 Helpers

- `nix run .#tf2nix resource.tf` - Converts HCL files to Nix.
- `nix run .#json2nix resource.yaml` - Converts JSON or YAML files to Nix.

#### 🧩 Common Functions

Generalized functions for reuse are in [lib/terraform.nix](lib/terraform.nix) and [nix/terranix.nix](nix/terranix.nix).

### 🔄 Updates

This project uses [nix flakes](https://nixos.wiki/wiki/Flakes) to manage [nixpkgs](https://github.com/NixOS/nixpkgs) versions. To upgrade, use `nix flake update` for all inputs or `nix flake update nixpkgs` to update a single flake input.

To check if a remote system is behind your flake state, run `nix run .#nix-upgrades`:

```sh
🔍 Scanning for upgradable hosts...

dev-vm: ⚠️ Modified: 24.05.20240618.938aa15
```

### 🤖 CI/CD

I utilize the [Nix Hydra project](https://github.com/NixOS/hydra) to test and build all packages and hosts, strictly following the `Zero Hydra Failures` paradigm to ensure every build is successful and stable.

You can view all our jobs and their statuses at [build.nix.srx.digital](https://build.nix.srx.digital/).

## 🚧 Reporting issues

If you experience any issues with the infrastructure, please [post a new issue to this repository](https://code.srx.digital/srx/srx-platform-nix/issues).

## 💬 Contact

Need help with Nix? Write me an e-mail to book an appointment for Nix/NixOS/DevOps related topics. You can find me at:

- [SRX Digital - Development & Operations](https://srx.digital/)
- [Nix Hamburg Matrix channel](https://matrix.to/#/#nix-hh:curious.bio) for live discussions.

## 📚 Links

- [Nix packages search](https://search.nixos.org/packages)
- [NixOS options search](https://search.nixos.org/options)
- [Nix Manual](https://nix.dev/manual/nix/stable/)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)
- [NixOS Wiki](https://nixos.wiki/wiki/Main_Page)
- [Awesome Nix](https://github.com/nix-communi/awesome-nix)

## 📜 License

All files in this repository are licensed under the terms of the MIT License (MIT). Please refer to the full license text in [LICENSE](LICENSE.md).
