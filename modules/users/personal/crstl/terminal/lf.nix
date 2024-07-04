{
  programs.lf = {
    enable = true;

    settings = {
      number = true;
      ratios = [
        1
        1
        2
      ];
      tabstop = 4;

      preview = true;
      hidden = true;
      drawbox = true;
      icons = true;
      ignorecase = true;
    };

    commands = {
      get-mime-type = ''%xdg-mime query filetype "$f"'';
    };
  };
}
