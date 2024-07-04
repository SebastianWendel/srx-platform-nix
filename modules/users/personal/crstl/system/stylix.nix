{
  stylix = {
    enable = true;
    fonts = {
      sizes = {
        desktop = 12;
        applications = 12;
        terminal = 12;
        popups = 12;
      };
    };

    opacity = {
      terminal = 0.9;
      applications = 0.9;
      popups = 0.9;
      desktop = 0.9;
    };

    targets = {
      gnome.enable = true;
      waybar = {
        enableCenterBackColors = true;
        enableRightBackColors = true;
        enableLeftBackColors = true;
      };
    };
  };
}
