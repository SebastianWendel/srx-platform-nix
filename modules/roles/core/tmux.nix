{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    aggressiveResize = true;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 10000;
    newSession = false;
    shortcut = "y";
    terminal = "tmux-256color";
  };
}
