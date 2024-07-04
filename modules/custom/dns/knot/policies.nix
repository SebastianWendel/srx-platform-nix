{
  services.knot.settings.policy = {
    denic_13 = {
      keystore = "default";
      signing-threads = 4;
      algorithm = "ecdsap256sha256";
      ksk-submission = "denic";
      ksk-lifetime = "365d";
      zsk-lifetime = "30d";
      propagation-delay = "1d";
    };

    denic_13_test = {
      keystore = "default";
      signing-threads = 4;
      algorithm = "ecdsap256sha256";
      ksk-submission = "denic";
      ksk-lifetime = "14d";
      zsk-lifetime = "3d";
      propagation-delay = "1d";
    };
  };
}
