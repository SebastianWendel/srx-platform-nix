{ pkgs, ... }:
{
  home.shellAliases = {
    cat = "${pkgs.bat}/bin/bat --style=plain";
    less = "${pkgs.bat}/bin/bat --style=plain";
  };

  programs.bat = {
    enable = true;
    config = {
      color = "always";
      pager = "less -FR";
      style = "numbers,changes,header";
      map-syntax = [
        "*.hcl:Terraform"
        "*.tf.json:Terraform"
        "*.ino:C++"
      ];
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batgrep
      batman
      batwatch
    ];
  };
}
