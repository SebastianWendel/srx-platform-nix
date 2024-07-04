{
  # nixpkgs_out_of_date = {
  #   condition = ''(time() - flake_input_last_modified{input="nixpkgs"}) / (60 * 60 * 24) > 7'';
  #   time = "1h";
  #   description = "{{$labels.host}} cannot reach nfs export [{{$labels.server}}]:{{$labels.path}}";
  # };
}
