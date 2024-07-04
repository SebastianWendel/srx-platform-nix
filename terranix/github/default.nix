{
  terraform.required_providers.github = {
    source = "registry.terraform.io/integrations/github";
    version = ">= 6.2.1";
  };

  imports = [
    ./srx.digital.nix
  ];
}
