{
  terraform.required_providers.keycloak = {
    source = "registry.terraform.io/mrparkers/keycloak";
    version = ">= 4.4.0";
  };

  provider.keycloak = { };

  imports = [
    ./srx.digital.nix
  ];
}
