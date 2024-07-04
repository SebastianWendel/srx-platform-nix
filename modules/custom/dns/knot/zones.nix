{
  services.knot.settings.zone = {
    "whoami.srx.digital".module = "mod-whoami";
    "whoami6.srx.digital".module = "mod-whoami";
    "srx81.de" = {
      dnssec-signing = true;
      dnssec-policy = "denic_13_test";
    };
  };
}
