{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    interactiveShellInit = "source '${pkgs.grml-zsh-config}/etc/zsh/zshrc'";
  };
}
