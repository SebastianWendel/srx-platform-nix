{ lib, ... }: {
  terraform.required_providers.hcloud = {
    source = "registry.terraform.io/hetznercloud/hcloud";
    version = ">= 1.45.0";
  };

  resource.hcloud_server.srxk8s00 = {
    name = "srxk8s00";
    server_type = "cax21";
    image = "debian-12";
    datacenter = "nbg1-dc3";
    public_net = {
      ipv4_enabled = true;
      ipv6_enabled = true;
    };
    ssh_keys = lib.tfRef "data.hcloud_ssh_keys.all_keys.ssh_keys.*.name";
  };

  data.hcloud_ssh_keys.all_keys = { };
}
