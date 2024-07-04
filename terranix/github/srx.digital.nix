{
  resource = {
    github_user_ssh_key.swendel = {
      title = "swendel";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwyxpc0pVB46j1k5VCSabvI4TUADvAabnxlE5+D5o2l";
    };

    github_repository = {
      github-repo-profile = {
        name = "SebastianWendel";
        description = "My personal GitHub profile.";
        homepage_url = "https://srx.digital";
        has_issues = false;
        visibility = "public";
        vulnerability_alerts = false;
      };

      srx-platform-nix = {
        name = "srx-platform-nix";
        description = "srx.digital - nix platform repository. Mirror of https://code.srx.digital/srx/srx-platform-nix/";
        homepage_url = "https://srx.digital";
        has_issues = false;
        visibility = "public";
        vulnerability_alerts = false;
      };
    };
  };
}
