{
  terraform.backend.s3 = {
    endpoints.s3 = "https://s3.srx.digital";
    bucket = "terraform-state";
    region = "eu-central-1";
    key = "srx.digital.tfstate";

    skip_credentials_validation = true;
    skip_requesting_account_id = true;
    skip_metadata_api_check = true;
    skip_region_validation = true;
    use_path_style = true;
  };
}