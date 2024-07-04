{
  resource = {
    minio_s3_bucket.nix-cache.bucket = "nix-cache";

    minio_iam_user.nix-hydra.name = "nix-hydra";
    minio_iam_service_account.nix-hydra.target_user = "\${minio_iam_user.nix-hydra.name}";

    minio_iam_policy = {
      nix-cache-policy-hydra = {
        name = "nix-cache-policy-hydra";
        policy = "\${data.minio_iam_policy_document.nix-cache-policy-hydra.json}";
      };
      nix-cache-policy-hydra-read = {
        name = "nix-cache-policy-hydra-read";
        policy = "\${data.minio_iam_policy_document.nix-cache-policy-hydra-read.json}";
      };
    };
    minio_iam_user_policy_attachment.nix-cache-policy-hydra = {
      user_name = "\${minio_iam_user.nix-hydra.id}";
      policy_name = "\${minio_iam_policy.nix-cache-policy-hydra.id}";
    };
  };

  data = {
    minio_iam_policy_document.nix-cache-policy-hydra-read.statement = {
      sid = "AllowDirectReads";
      actions = [
        "s3:GetObject"
        "s3:GetBucketLocation"
      ];
      effect = "Allow";
      resources = [
        "\${minio_s3_bucket.nix-cache.arn}"
        "\${minio_s3_bucket.nix-cache.arn}/*"
      ];
      principal = "*";
    };

    minio_iam_policy_document.nix-cache-policy-hydra.statement = {
      sid = "AuthenticatedWrite";
      actions = [ "s3:*" ];
      effect = "Allow";
      resources = [
        "\${minio_s3_bucket.nix-cache.arn}"
        "\${minio_s3_bucket.nix-cache.arn}/*"
      ];
      principal = "*";
    };
  };

  output = {
    nix-hydra-id.value = "\${minio_iam_user.nix-hydra.id}";
    nix-hydra-secret = {
      value = "\${minio_iam_user.nix-hydra.secret}";
      sensitive = true;
    };
    nix-hydra-status.value = "\${minio_iam_user.nix-hydra.status}";
    nix-hydra-access-key.value = "\${minio_iam_service_account.nix-hydra.access_key}";
    nix-hydra-secret-key = {
      value = "\${minio_iam_service_account.nix-hydra.secret_key}";
      sensitive = true;
    };
    nix-cache-url.value = "\${minio_s3_bucket.nix-cache.bucket_domain_name}";
  };
}
