{
  terraform.required_providers.minio = {
    source = "registry.terraform.io/aminueza/minio";
    version = ">= 2.2.0";
  };

  provider.minio = { };

  imports = [
    ./admins.nix
    ./terraform.nix
    ./hydra.nix
  ];
}
