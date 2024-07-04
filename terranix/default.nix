{
  terraform.required_version = ">= 1.7";

  imports = [
    ./backend.nix
    ./variables.nix

    ./github
    ./gitea
    ./hcloud
    ./hydra
    ./minio
    ./keycloak
    ./grafana
  ];
}
