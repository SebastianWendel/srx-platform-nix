{ lib, pkgs, ... }:
{
  stylix.targets.vscode.enable = false;

  home = {
    packages = with pkgs; [
      # git
      gitFull

      # env
      direnv
      vscode-langservers-extracted

      # nix
      nil
      nixd
      nixpkgs-fmt
      nixfmt-rfc-style
      deadnix
      statix

      # golang
      go
      goperf
      libcap
      gcc

      # devops
      opentofu
      kubectl
      kubernetes-helm
    ];

    sessionVariables.GOPATH = "/home/crstl/Development/golang";
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;

    mutableExtensionsDir = false;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    userSettings = {
      telemetry.telemetryLevel = "off";
      gitlens.telemetry.enabled = false;
      redhat.telemetry.enabled = false;

      window = {
        zoomLevel = 1;
        menuBarVisibility = "toggle";
      };

      editor = {
        inlineSuggest.enabled = true;
        minimap.enabled = false;
        autoIndent = "full";
        autoSurround = "brackets";
      };

      workbench = {
        iconTheme = "material-icon-theme";
        colorTheme = "Material Theme Palenight High Contrast";
        editor.enablePreview = false;
        list.smoothScrolling = true;
        startupEditor = "none";
        welcomePage.walkthroughs.openOnInstall = false;
      };

      update.showReleaseNotes = false;

      nix = {
        enableLanguageServer = true;
        serverPath = "${lib.getExe pkgs.nil}";
        serverSettings.nil = {
          formatting.command = [ (lib.getExe pkgs.nixpkgs-fmt) ];
          nix = {
            binary = lib.getExe pkgs.nix;
            maxMemoryMB = 4096;
            flake = {
              autoArchive = true;
              autoEvalInputs = true;
              nixpkgsInputName = "nixpkgs";
            };
          };
        };
      };

      "[jsonc]".editor.defaultFormatter = "vscode.json-language-features";
      "[nix]".editor.defaultFormatter = "jnoortheen.nix-ide";

      github.copilot.chat.welcomeMessage = "never";

      genieai = {
        promptPrefix = {
          explain = "gpt.explain";
          addComments = "gpt.comments";
          completeCode = "gpt.complete";
          optimize = "gpt.optimize";
          findProblems = "gpt.find";
          addTests = "gpt.test";
        };
        openai = {
          model = "gpt-4";
          temperature = 0.7;
        };
        response = {
          showNotification = true;
        };
      };
    };

    extensions = with pkgs.vscode-extensions; [
      # themes & icons
      equinusocio.vsc-material-theme
      pkief.material-icon-theme
      pkief.material-product-icons

      # visualize
      ## kamikillerto.vscode-colorize
      oderwat.indent-rainbow

      # formater
      esbenp.prettier-vscode
      formulahendry.auto-close-tag
      formulahendry.auto-rename-tag
      jkillian.custom-local-formatters
      shardulm94.trailing-spaces
      tyriar.sort-lines

      # lang
      streetsidesoftware.code-spell-checker

      # file
      redhat.vscode-yaml

      # env
      editorconfig.editorconfig
      irongeek.vscode-env
      mikestead.dotenv
      formulahendry.code-runner

      # git
      codezombiech.gitignore
      donjayamanne.githistory
      mhutchie.git-graph

      # nix
      arrterian.nix-env-selector
      bbenoist.nix
      brettm12345.nixfmt-vscode
      jnoortheen.nix-ide
      mkhl.direnv

      # golang
      golang.go

      # web
      astro-build.astro-vscode
      bradlc.vscode-tailwindcss
      ritwickdey.liveserver

      # markdown
      bierner.markdown-mermaid
      davidanson.vscode-markdownlint
      unifiedjs.vscode-mdx
      marp-team.marp-vscode

      # container
      ms-kubernetes-tools.vscode-kubernetes-tools
      ms-vscode-remote.remote-ssh
      ms-vscode-remote.remote-containers

      # devops
      hashicorp.hcl
      hashicorp.terraform
      github.vscode-github-actions

      # ai
      github.copilot
      github.copilot-chat
      genieai.chatgpt-vscode
      visualstudioexptteam.vscodeintellicode
      visualstudioexptteam.intellicode-api-usage-examples
    ];

    globalSnippets = {
      fixme = {
        prefix = [ "fixme" ];
        description = "Insert a FIXME remark";
        body = [ "$LINE_COMMENT FIXME: $0" ];
      };
    };
  };
}
