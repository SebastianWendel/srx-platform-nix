{ lib, ... }: {
  resource = {
    hydra_project.srx = {
      name = "srx";
      display_name = "srx.digital";
      description = "srx.digital NixOS Platform";
      homepage = "https://code.srx.digital/srx/";
      owner = lib.tfRef "var.USERNAME_PERSONAL";
      enabled = true;
      visible = true;
    };

    hydra_jobset = {
      srx-platform-nix = {
        name = "srx-platform-nix";
        project = lib.tfRef "hydra_project.srx.name";
        type = "flake";
        flake_uri = "git+ssh://forgejo@code.srx.digital/srx/srx.infra.nix.history.git";
        description = "srx.digital NixOS Platform";
        state = "enabled";
        check_interval = 60;
        scheduling_shares = 10000;
        keep_evaluations = 5;
        visible = true;
        email_notifications = true;
        email_override = lib.tfRef "var.EMAIL_PUBLIC";
        depends_on = [ "hydra_project.srx" ];
      };

      srx-website-nix = {
        name = "website";
        project = lib.tfRef "hydra_project.srx.name";
        type = "flake";
        flake_uri = "git+ssh://forgejo@code.srx.digital/srx/srx.astro.nix.git";
        description = "A Nix development environment of my portfolio page based on Astro";
        state = "enabled";
        check_interval = 60;
        scheduling_shares = 1000;
        keep_evaluations = 5;
        visible = true;
        email_notifications = true;
        email_override = lib.tfRef "var.EMAIL_PUBLIC";
        depends_on = [ "hydra_project.srx" ];
      };

      srx-shadow-nix = {
        name = "nixos-shadow";
        project = lib.tfRef "hydra_project.srx.name";
        type = "flake";
        flake_uri = "git+ssh://forgejo@code.srx.digital/srx/srx-nixos-shadow.git";
        description = "The hidden part of the srx.digital NixOS platform";
        state = "enabled";
        check_interval = 60;
        scheduling_shares = 1000;
        keep_evaluations = 5;
        visible = false;
        email_notifications = true;
        email_override = lib.tfRef "var.EMAIL_PUBLIC";
        depends_on = [ "hydra_project.srx" ];
      };
    };
  };
}
