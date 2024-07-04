{
  programs = {
    command-not-found.enable = false;
    nix-index = {
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
