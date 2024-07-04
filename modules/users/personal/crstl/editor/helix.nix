{ lib, pkgs, ... }:
{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      ansible-language-server
      clang-tools
      delve
      gitFull
      go
      gopls
      jsonnet-language-server
      lldb
      lua-language-server
      marksman
      nil
      nodePackages.bash-language-server
      openscad-lsp
      python3Packages.pylsp-mypy
      python3Packages.pylsp-rope
      python3Packages.python-lsp-server
      taplo
      terraform-ls
      vscode-langservers-extracted
      yaml-language-server
    ];

    settings = {
      editor = {
        shell = [ "zsh" "-c" ];
        line-number = "relative";
        rulers = [ 80 120 ];

        gutters = [
          "diagnostics"
          "line-numbers"
          "spacer"
          "diff"
        ];

        auto-format = true;
        auto-info = true;

        completion-replace = true;
        completion-trigger-len = 1;

        idle-timeout = 200;
        true-color = true;

        bufferline = "always";
        color-modes = true;

        cursorline = true;
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        statusline = {
          left = [
            "mode"
            "selections"
            "spinner"
            "file-name"
            "total-line-numbers"
          ];
          center = [ ];
          right = [
            "diagnostics"
            "file-encoding"
            "file-line-ending"
            "file-type"
            "position-percentage"
            "position"
          ];
          mode = {
            normal = "N     ";
            insert = "   INS";
            select = "SELECT";
          };
          separator = "";
        };

        lsp.display-messages = true;
      };

      keys.normal = {
        space = {
          space = "file_picker";
          w = ":w";
          q = ":q";
        };
        esc = [
          "collapse_selection"
          "keep_primary_selection"
        ];
      };
    };

    languages = {
      language =
        let
          nodeLsp = [
            {
              name = "typescript";
              except-features = [ "format" ];
            }
            {
              name = "prettier";
              only-features = [ "format" ];
            }
            "eslint"
          ];
        in
        [
          {
            name = "bash";
            auto-format = true;
            file-types = [
              "sh"
              "bash"
            ];
            formatter = {
              command = "${pkgs.shfmt}/bin/shfmt";
              args = [
                "-i 4" # indent with 2 spaces
                "-s" # simplify the code
                "-ci" # indent switch cases
                "-sr" # add space after redirection
              ];
            };
            language-servers = [ "bash" ];
          }
          {
            name = "typescript";
            language-servers = nodeLsp;
          }
          {
            name = "javascript";
            language-servers = nodeLsp;
          }
          {
            name = "jsx";
            language-servers = nodeLsp;
          }
          {
            name = "tsx";
            language-servers = nodeLsp;
          }
          {
            name = "sql";
            formatter.command = "${pkgs.pgformatter}/bin/pg_format";
          }
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.alejandra}/bin/alejandra";
            language-servers = [ "nil" ];
          }
          {
            name = "go";
            auto-format = true;
            formatter.command = "${pkgs.go}/bin/gofmt";
            language-servers = [ "go" ];
          }
          {
            name = "rust";
            auto-format = true;
            language-servers = [ "rust-analyzer" ];
            file-types = [ "rs" ];
          }
          {
            name = "xml";
            file-types = [ "xml" ];
            formatter = {
              command = "${pkgs.yq-go}/bin/yq";
              args = [
                "--input-format"
                "xml"
                "--output-format"
                "xml"
                "--indent"
                "2"
              ];
            };
          }
        ];

      language-server = {
        # check: hx --health [LANG]

        bash = with pkgs.nodePackages; {
          command = "${bash-language-server}/bin/bash-language-server";
          args = [ "start" ];
        };

        go = {
          command = "${pkgs.gopls}/bin/gopls";
        };

        nil = {
          command = "${pkgs.nil}/bin/nil";
          config.nil = {
            formatter.command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
            nix.flake.autoEvalInputs = true;
          };
        };

        rust-analyzer = {
          config.rust-analyzer = {
            cargo.loadOutDirsFromCheck = true;
            checkOnSave.command = "clippy";
            procMacro.enable = true;

            lens = {
              references = true;
              methodReferences = true;
            };

            completion.autoimport.enable = true;
            experimental.procAttrMacros = true;
          };
        };

        typescript = with pkgs.nodePackages; {
          command = "${typescript-language-server}/bin/typescript-language-server";
          args = [
            "--stdio"
            "--tsserver-path=${typescript}/lib/node_modules/typescript/lib"
          ];
        };

        prettier = with pkgs; {
          command = "${efm-langserver}/bin/efm-langserver";
          config = {
            documentFormatting = true;
            languages =
              lib.genAttrs
                [
                  "typescript"
                  "javascript"
                  "typescriptreact"
                  "javascriptreact"
                  "vue"
                  "json"
                  "markdown"
                ]
                (_: [
                  {
                    formatCommand = "${nodePackages.prettier}/bin/prettier --stdin-filepath \${INPUT}";
                    formatStdin = true;
                  }
                ]);
          };
        };

        eslint = with pkgs.nodePackages; {
          command = "${eslint}/bin/eslint";
          args = [ "--stdio" ];
          config = {
            validate = "on";
            packageManager = "yarn";
            useESLintClass = false;
            codeActionOnSave.mode = "all";
            format = true;
            quiet = false;
            onIgnoredFiles = "off";
            rulesCustomizations = [ ];
            run = "onType";
            nodePath = "";
            workingDirectory.mode = "auto";
            experimental = { };
            problems.shortenToSingleLine = false;
            codeAction = {
              disableRuleComment = {
                enable = true;
                location = "separateLine";
              };
              showDocumentation.enable = true;
            };
          };
        };
      };
    };
  };
}
