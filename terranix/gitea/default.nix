{
  terraform.required_providers.gitea = {
    source = "registry.terraform.io/go-gitea/gitea";
    version = ">= 0.3.0";
  };

  imports = [
    ./swendel.nix
    ./srx.digital.nix
    ./nix-hamburg.de.nix
    ./curious.bio.nix
    ./octopot.de.nix
  ];
}
