{
  services.knot.settings.remote = {
    srxgp00 = {
      address = [ "10.80.0.1@853" ];
      cert-key = "EPap376f5O3gAIt36SaTceDgyE90GaANE9YCcjSRUbA=";
      quic = true;
    };

    srxgp01 = {
      address = [ "10.80.0.5@853" ];
      cert-key = "DFloXBI1hyI/aTGSEc+3ZjoeVz7a7Vi5AeP5ouKaByI=";
      quic = true;
    };

    srxgp02 = {
      address = [ "10.80.0.6@853" ];
      cert-key = "oq6Ig/gcTr7VCn7gQQjuMN2txkVZIJ58iSvrisxKE20=";
      quic = true;
    };

    # denic
    a_nic_de.address = [
      "194.0.0.53"
      "2001:678:2::53"
    ];
    f_nic_de.address = [
      "81.91.164.5"
      "2a02:568:0:2::53"
    ];
    l_de_net.address = [
      "77.67.63.105"
      "2001:668:1f:11::105"
    ];
    n_de_net.address = [
      "194.146.107.6"
      "2001:67c:1011:1::53"
    ];
    s_de_net.address = [
      "195.243.137.26"
      "2003:8:14::53"
    ];
    z_nic_de.address = [
      "194.246.96.1"
      "2a02:568:fe02::de"
    ];

    # digital
    v0n0_nic_digital.address = [
      "65.22.20.36"
      "2a01:8840:16::36"
    ];
    v0n1_nic_digital.address = [
      "65.22.21.36"
      "2a01:8840:17::36"
    ];
    v0n2_nic_digital.address = [
      "65.22.22.36"
      "2a01:8840:18::36"
    ];
    v0n3_nic_digital.address = [
      "161.232.10.36"
      "2a01:8840:f4::36"
    ];
    v2n0_nic_digital.address = [
      "65.22.23.36"
      "2a01:8840:19::36"
    ];
    v2n1_nic_digital.address = [
      "161.232.11.36"
      "2a01:8840:f5::36"
    ];
  };
}
