{ config, ... }:
{
  age.secrets = {
    knot_key_xfr = {
      file = ./tsig_xfr.age;
      owner = "knot";
    };

    knot_key_transfer = {
      file = ./transfer.age;
      owner = "knot";
    };

    knot_key_notify = {
      file = ./notify.age;
      owner = "knot";
    };

    knot_key_update = {
      file = ./update.age;
      owner = "knot";
    };

    knot_key_update_k8s = {
      file = ./update_k8s.age;
      owner = "knot";
    };

    knot_key_update_terraform_swendel = {
      file = ./update_terraform_swendel.age;
      owner = "knot";
    };

    knot_key_update_terraform_cicd = {
      file = ./update_terraform_cicd.age;
      owner = "knot";
    };
  };

  services.knot.keyFiles = [
    config.age.secrets.knot_key_xfr.path
    config.age.secrets.knot_key_transfer.path
    config.age.secrets.knot_key_notify.path
    config.age.secrets.knot_key_update.path
    config.age.secrets.knot_key_update_k8s.path
    config.age.secrets.knot_key_update_terraform_swendel.path
    config.age.secrets.knot_key_update_terraform_cicd.path
  ];
}
