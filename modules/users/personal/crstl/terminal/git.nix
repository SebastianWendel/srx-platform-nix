{ pkgs, lib, config, ... }:
{
  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;
      userName = "Sebastian Wendel";
      userEmail = "swendel@srx.digital";
      aliases = {
        amend = "commit --amend -C HEAD";
        authors =
          ''!"${pkgs.git}/bin/git log --pretty=format:%aN''
          + " | ${pkgs.coreutils}/bin/sort"
          + " | ${pkgs.coreutils}/bin/uniq -c"
          + " | ${pkgs.coreutils}/bin/sort -rn\"";
        b = "branch --color -v";
        ca = "commit --amend";
        changes = "diff --name-status -r";
        clone = "clone --recursive";
        co = "checkout";
        cp = "cherry-pick";
        dc = "diff --cached";
        dh = "diff HEAD";
        ds = "diff --staged";
        from = "!${pkgs.git}/bin/git bisect start && ${pkgs.git}/bin/git bisect bad HEAD && ${pkgs.git}/bin/git bisect good";
        ls-ignored = "ls-files --exclude-standard --ignored --others";
        rc = "rebase --continue";
        rh = "reset --hard";
        ri = "rebase --interactive";
        rs = "rebase --skip";
        ru = "remote update --prune";
        snap = "!${pkgs.git}/bin/git stash" + " && ${pkgs.git}/bin/git stash apply";
        snaplog =
          "!${pkgs.git}/bin/git log refs/snapshots/refs/heads/" + "$(${pkgs.git}/bin/git rev-parse HEAD)";
        spull =
          "!${pkgs.git}/bin/git stash" + " && ${pkgs.git}/bin/git pull" + " && ${pkgs.git}/bin/git stash pop";
        su = "submodule update --init --recursive";
        undo = "reset --soft HEAD^";
        w = "status -sb";
        wdiff = "diff --color-words";
        l =
          "log --graph --pretty=format:'%Cred%h%Creset"
          + " —%Cblue%d%Creset %s %Cgreen(%cr)%Creset'"
          + " --abbrev-commit --date=relative --show-notes=*";
      };

      extraConfig = {
        core = {
          editr = "${lib.getExe pkgs.vscodium-fhs} --wait";
          pager = "${lib.getExe pkgs.bat}";
          trustctime = false;
          logAllRefUpdates = true;
          precomposeunicode = false;
          whitespace = "trailing-space,space-before-tab";
        };
        branch.autosetupmerge = true;
        credential.helper = "${pkgs.pass-git-helper}/bin/pass-git-helper";
        ghi.token = "!${pkgs.pass}/bin/pass show api.github.com | head -1";
        github.user = "SebastianWendel";
        hub.protocol = "${pkgs.openssh}/bin/ssh";
        init.defaultBranch = "main";
        mergetool.keepBackup = true;
        pull.rebase = true;
        rebase.autosquash = true;
        rerere.enabled = true;
        color = {
          status = "auto";
          diff = "auto";
          branch = "auto";
          interactive = "auto";
          ui = "auto";
          sh = "auto";
        };
      };
    };

    gitui.enable = true;
  };

  services.git-sync = {
    enable = false;
    repositories = {
      "srx.digital.astro" = {
        path = "${config.home.homeDirectory}/Development/web/srx.digital.astro";
        uri = "forgejo@code.srx.digital:srx/srx.infra.nix.history.git";
      };
      "srx.infra.nix" = {
        path = "${config.home.homeDirectory}/Development/nix/srx.infra.nix";
        uri = "forgejo@code.srx.digital:srx/srx.infra.nix.history.git";
      };
      "srx.shadow.nix" = {
        path = "${config.home.homeDirectory}/Development/nix/srx.shadow.nix";
        uri = "forgejo@code.srx.digital:srx/srx-nixos-shadow.git";
      };
      "nixpkgs" = {
        path = "${config.home.homeDirectory}/Development/nix/nixpkgs";
        uri = "git@github.com:SebastianWendel/nixpkgs.git";
      };
    };
  };
}
