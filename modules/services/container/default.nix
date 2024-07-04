{ pkgs, ... }:
{
  virtualisation = {
    containers = {
      enable = true;
      registries.search = [
        "docker.io"
        "quay.io"
        "code.srx.digital"
      ];

      ociSeccompBpfHook.enable = true;
      containersConf.settings.engine.helper_binaries_dir = [ "${pkgs.netavark}/bin" ];
    };
  };
}
