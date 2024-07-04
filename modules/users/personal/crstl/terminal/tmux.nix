{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 10000;
    newSession = false;
    secureSocket = false;
    terminal = "tmux-256color";
  };
}
