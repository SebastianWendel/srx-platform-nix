{
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "srxtab00";
          outputs = [{
            criteria = "Sharp Corporation LQ100P1JX51 Unknown";
            scale = 1.1;
          }];
        };
      }
      {
        profile = {
          name = "srxws00";
          outputs = [
            {
              criteria = "Dell Inc. DELL P3223QE 8HG75P3";
              status = "enable";
              mode = "3840x2160";
              position = "0,950";
              scale = 1.1;
            }
            {
              criteria = "Dell Inc. DELL P3223QE 7HN7BP3";
              status = "enable";
              mode = "3840x2160";
              position = "3480,0";
              transform = "270";
              scale = 1.1;
            }
          ];
        };
      }
      {
        profile = {
          name = "srxws01";
          outputs = [
            {
              criteria = "Dell Inc. DELL U2415 7MT017CQ2NWU";
              status = "enable";
              mode = "1920x1200";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "Dell Inc. DELL U2715H GH85D7920WHS";
              status = "enable";
              mode = "2560x1440";
              position = "1920,0";
              transform = "90";
              scale = 1.0;
            }
            {
              criteria = "Dell Inc. DELL U2415 7MT016C80UAS";
              status = "enable";
              mode = "1920x1200";
              position = "3360,0";
              scale = 1.0;
            }
          ];
        };
      }
    ];
  };
}
