{
  services.knot.settings.acl = {
    notify.action = "notify";

    transfer = {
      action = "transfer";
      address = [
        "10.80.0.5" # srxgp01
        "10.80.0.6" # srxgp02
      ];
    };

    update = {
      action = "update";
      address = [
        "10.80.0.0/24"
        "127.0.0.1"
        "::1/128"
      ];
      key = "update";
    };

    update_k8s = {
      action = "update";
      address = [
        "10.80.0.0/24"
        "127.0.0.1"
        "::1/128"
      ];
      key = "update_k8s";
    };

    update_terraform_swendel = {
      action = "update";
      address = [
        "10.80.0.0/24"
        "127.0.0.1"
        "::1/128"
      ];
      key = "update_terraform_swendel";
    };

    update_terraform_cicd = {
      action = "update";
      address = [
        "10.80.0.0/24"
        "127.0.0.1"
        "::1/128"
      ];
      key = "update_terraform_cicd";
    };
  };
}
