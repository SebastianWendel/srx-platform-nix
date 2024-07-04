{
  services = {
    fail2ban = {
      enable = true;
      maxretry = 5;

      bantime-increment = {
        enable = true;
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "168h";
        overalljails = true;
      };

      ignoreIP = [
        "10.0.0.0/8"
        "192.168.0.0/16"
        "116.202.144.14/28"
        "116.202.240.209/26"
        "65.108.77.254/26"
        "2a01:4f8:241:3e69::/64"
        "2a01:4f9:6b:2573::/64"
        "srxgp00.srx.digital"
        "srxgp01.srx.digital"
        "srxgp02.srx.digital"
        "srxk8s00.srx.digital"
      ];
    };
  };
}
