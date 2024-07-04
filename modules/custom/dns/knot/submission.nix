{
  services.knot.settings.submission = {
    denic = {
      parent = [
        "a_nic_de"
        "f_nic_de"
        "l_de_net"
        "n_de_net"
        "s_de_net"
        "z_nic_de"
      ];
      check-interval = "120s";
    };

    digital = {
      parent = [
        "v0n0_nic_digital"
        "v0n1_nic_digital"
        "v0n2_nic_digital"
        "v0n3_nic_digital"
        "v2n0_nic_digital"
        "v2n1_nic_digital"
      ];
      check-interval = "120s";
    };
  };
}
