{
  terraform.required_providers.hydra = {
    source = "registry.terraform.io/DeterminateSystems/hydra";
    version = ">= 0.1.2";
  };

  provider.hydra = { };

  imports = [
    ./srx.digital.nix
  ];
}
