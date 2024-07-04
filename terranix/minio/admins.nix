{
  resource = {
    minio_iam_user.swendel.name = "swendel";

    minio_iam_service_account.swendel.target_user = "\${minio_iam_user.swendel.name}";

    minio_iam_user_policy_attachment.swendel-policy-admin = {
      user_name = "\${minio_iam_user.swendel.id}";
      policy_name = "consoleAdmin";
    };
  };

  output = {
    swendel-id.value = "\${minio_iam_user.swendel.id}";

    swendel-secret = {
      value = "\${minio_iam_user.swendel.secret}";
      sensitive = true;
    };

    swendel-status.value = "\${minio_iam_user.nix-hydra.status}";

    swendel-access-key = {
      value = "\${minio_iam_service_account.swendel.access_key}";
      sensitive = true;
    };

    swendel-secret-key = {
      value = "\${minio_iam_service_account.swendel.secret_key}";
      sensitive = true;
    };
  };
}
