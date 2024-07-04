{ lib, ... }: {
  terraform.required_providers.grafana = {
    source = "registry.terraform.io/grafana/grafana";
    version = ">= 2.14.3";
  };

  resource = {
    grafana_organization.srx = {
      name = "srx.digital - Development & Operations";
      admin_user = lib.tfRef "var.USERNAME_ADMIN";
      create_users = false;
    };

    grafana_organization_preferences.srx = {
      timezone = "browser";
      week_start = "monday";
      depends_on = [ "grafana_organization.srx" ];
    };
  };
}
