{
  resource = {
    minio_s3_bucket.terraform-state.bucket = "terraform-state";

    minio_s3_bucket_versioning.terraform-state = {
      bucket = "terraform-state";
      versioning_configuration.status = "Enabled";
      depends_on = [ "minio_s3_bucket.terraform-state" ];
    };
  };

  output = {
    terraform-url.value = "\${minio_s3_bucket.terraform-state.bucket_domain_name}";
  };
}
