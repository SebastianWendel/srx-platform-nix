{ config, inputs, lib, ... }:
{
  imports = with inputs; [
    nixos-hardware.nixosModules.common-gpu-nvidia
  ];

  hardware = {
    nvidia = {
      modesetting.enable = lib.mkDefault true;
      powerManagement.enable = lib.mkDefault true;
      nvidiaPersistenced = lib.mkDefault true;
      package = lib.mkForce config.boot.kernelPackages.nvidiaPackages.stable;
    };

    nvidia-container-toolkit.enable = lib.mkDefault true;

    opengl = {
      enable = lib.mkDefault true;
      driSupport = lib.mkDefault true;
      driSupport32Bit = lib.mkDefault true;
    };
  };

  boot.blacklistedKernelModules = [ "nouveau" ];

  # nixpkgs.config = {
  #   allowUnfree = lib.mkForce true;
  #   cudaSupport = lib.mkForce true;
  #   allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "cudatoolkit" ];
  # };

  services.xserver.videoDrivers = [ "nvidia" ];

  virtualisation = {
    docker.enableNvidia = lib.mkIf config.virtualisation.docker.enable true;
    podman.enableNvidia = lib.mkIf config.virtualisation.podman.enable true;
  };

  #services.telegraf.extraConfig.inputs.nvidia_smi.bin_path = "${config.hardware.nvidia.package}/bin/nvidia-smi";
}
