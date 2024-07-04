{
  services.knot.settings.template = {
    default = {
      semantic-checks = true;
      zonemd-generate = "zonemd-sha384";
      zonefile-load = "difference-no-serial";
      zonefile-sync = "-1";
      serial-policy = "unixtime";
      journal-content = "all";

      notify = [ "srxgp01" "srxgp02" ];

      acl = [
        "transfer"
        "update"
        "update_k8s"
        "update_terraform_cicd"
        "update_terraform_swendel"
      ];

      global-module = [
        "mod-stats/all"
        "mod-cookies/default"
      ];
    };

    slave = {
      acl = [ "notify" ];
      master = "srxgp00";
      zonefile-load = "none";
      storage = "/var/lib/knot/slave";
    };
  };
}
