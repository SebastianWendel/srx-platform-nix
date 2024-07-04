{
  # FIXME: review this if it's still necessary
  #
  # CVE-2024-6387 https://github.com/NixOS/nixpkgs/pull/323753
  services.openssh.settings.LoginGraceTime = 0;
}
