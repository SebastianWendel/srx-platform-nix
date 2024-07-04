let
  inherit (builtins) attrNames attrValues mapAttrs listToAttrs;
  hosts = mapAttrs (_: v: v.pubkey) (import ./nix/hosts.nix).flake.hosts;

  srx_signing = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcf3QwjRB29nYbFTHbtZjiYAwDlLB0tLz8Djo5x/HYg";
  srx_swendel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB6vk3k1p6YMsGLFQ/xABLYK/VJicywkf1MJawnN7oXU";
  hydra_runner = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDjAHH3dWAxIi0ylYt3lEOnOd/Vx7u91F3ZIs+pIsUEC1BLUgULSiUvYgAI99FAPIbavcn2vSaDmHVFexlVltMY7V+I+F4Q/d96wfaTXq1t33PJUGOcbvBSRzspTJw5hRq6sGV7UPf0givVS0ZL8001S4SydziT/C+z+3EJXhk4RMJT2rkxw7KWFWWSRZYT4YsCcsMDjXyvV1GZXAZnTioIJ+JNi3zepUH0AWu/yhKO2k0drYJ3hzSSfbgehOLM9MXozPu90vHNiff7rw557LtzksJqRNNqIwPGZTcaNwuH/RQF7USe3juutf62fS7PCqoaaVIAhHVWq573VImCizwd42+qBqUgIjhaIJlyUAMQv7cQTnUDZoK8k7/gB3WN7a03bU6NcGpJvLR8HAM9RQCQXqCW2gQDLEnuHHOhHS4XsEovpvu3HigSi8FPLKrDtT/0b7ecmizYR/3IoRqiyE3RgUz+mpPGMKvYxKNQLXF5By0T7n4CWYPFdjVm7nM2APGrm3OHkbVyKKFi95YE0v/7P/8GRlVIKpLYU1DMnmDzEfjNOKokXG3JWTK/ZLkVUUNXuBbjNh8Q0cTUI/4NlgLgMecsNGhfxxr8TehDo/sZoxqhCFAPfyGRCJrIpnLSIxjEZmLRt2/wOxoZeaql4FsRQ7EqA579pGUUYTQCmpC1LQ==";

  secrets = with hosts; {
    "hosts/srxgp00/services/coturn/auth-secret.age" = [ srxgp00 ];
    "hosts/srxgp00/services/dendrite/environment.age" = [ srxgp00 ];
    "hosts/srxgp00/services/dendrite/private-key.age" = [ srxgp00 ];
    "hosts/srxgp00/services/forgejo/mailerPassword.age" = [ srxgp00 ];
    "hosts/srxgp00/services/forgejo/runnerToken.age" = [ srxgp00 ];
    "hosts/srxgp00/services/grafana/oidc-secret.age" = [ srxgp00 ];
    "hosts/srxgp00/services/hedgedoc/environment.age" = [ srxgp00 ];
    "hosts/srxgp00/services/hydra/private-key.age" = [ srxgp00 ];
    "hosts/srxgp00/services/hydra/secrets.age" = [ srxgp00 ];
    "hosts/srxgp00/services/keycloak/databasePassword.age" = [ srxgp00 ];
    "hosts/srxgp00/services/mailserver/mailbox-dmarc-client.age" = [ srxgp00 ];
    "hosts/srxgp00/services/mailserver/mailbox-dmarc.age" = [ srxgp00 ];
    "hosts/srxgp00/services/mailserver/mailbox-Ies6sh.age" = [ srxgp00 ];
    "hosts/srxgp00/services/mailserver/mailbox-Oom7oh.age" = [ srxgp00 ];
    "hosts/srxgp00/services/mailserver/mailbox-Osoo5u.age" = [ srxgp00 ];
    "hosts/srxgp00/services/mailserver/mailbox-ugai0U.age" = [ srxgp00 ];
    "hosts/srxgp00/services/mailserver/mailbox-xaev9B.age" = [ srxgp00 ];
    "hosts/srxgp00/services/minio/user_admin.age" = [ srxgp00 ];
    "hosts/srxgp00/services/minio/user_prometheus.age" = [ srxgp00 ];
    "hosts/srxgp00/services/nextcloud/adminpass.age" = [ srxgp00 ];
    "hosts/srxgp00/services/nextcloud/secrets.age" = [ srxgp00 ];
    "hosts/srxgp00/services/oauth2-proxy/secrets.age" = [ srxgp00 ];
    "hosts/srxgp00/services/openldap/ldap-bind-secret.age" = [ srxgp00 ];
    "hosts/srxgp00/services/openldap/ldap-config-secret.age" = [ srxgp00 ];
    "hosts/srxgp00/services/paperless/password.age" = [ srxgp00 ];
    "hosts/srxgp00/services/plausible/mail.age" = [ srxgp00 ];
    "hosts/srxgp00/services/plausible/password.age" = [ srxgp00 ];
    "hosts/srxgp00/services/plausible/secret.age" = [ srxgp00 ];
    "hosts/srxgp00/services/prometheus/alertmanager-env.age" = [ srxgp00 ];
    "hosts/srxgp00/services/restic/repo_key.age" = [ srxgp00 ];
    "hosts/srxgp00/services/restic/repo_ssh.age" = [ srxgp00 ];
    "hosts/srxgp00/services/vaultwarden/secrets.age" = [ srxgp00 ];
    "hosts/srxnb00/services/restic/repo_key.age" = [ srxnb00 ];
    "hosts/srxnb00/services/restic/repo_ssh.age" = [ srxnb00 ];
    "hosts/srxmc00/cifs_nas.age" = [ srxmc00 ];
    "modules/custom/dns/knot/secrets/notify.age" = [ srxgp00 srxgp01 srxgp02 ];
    "modules/custom/dns/knot/secrets/transfer.age" = [ srxgp00 srxgp01 srxgp02 ];
    "modules/custom/dns/knot/secrets/tsig_xfr.age" = [ srxgp00 srxgp01 srxgp02 ];
    "modules/custom/dns/knot/secrets/update_k8s.age" = [ srxgp00 srxgp01 srxgp02 ];
    "modules/custom/dns/knot/secrets/update_terraform_cicd.age" = [ srxgp00 srxgp01 srxgp02 ];
    "modules/custom/dns/knot/secrets/update_terraform_swendel.age" = [ srxgp00 srxgp01 srxgp02 ];
    "modules/custom/dns/knot/secrets/update.age" = [ srxgp00 srxgp01 srxgp02 ];
    "modules/services/container/k3s/k8s_cluster_token.age" = [ srxk8s00 ];
    "modules/services/container/k3s/k8s_dns_update_rfc2136.age" = [ srxk8s00 ];
    "modules/services/container/k3s/k8s_environment.age" = [ srxk8s00 ];
    "modules/services/container/k3s/k8s_traefik_dashboard.age" = [ srxk8s00 ];
    "modules/roles/server/acme.age" = attrValues hosts;
    "modules/users/personal/crstl/password.age" = attrValues hosts;
    "modules/users/system/automat/ssh-private.age" = attrValues hosts;
    "modules/users/system/root/password.age" = attrValues hosts;
  };

  secrets' = mapAttrs
    (_: v: {
      publicKeys = [
        srx_signing
        srx_swendel
        hydra_runner
      ] ++ v;
    })
    secrets;

  allHostSecret =
    secretName:
    listToAttrs (
      map
        (host: {
          name = "hosts/${host}/${secretName}.age";
          value.publicKeys = [
            srx_signing
            srx_swendel
            hydra_runner
            hosts.${host}
          ];
        })
        (attrNames hosts)
    );
in
secrets' //
allHostSecret "initrd_hostkey" //
allHostSecret "dns_update" //
allHostSecret "vpn_srx" //
allHostSecret "vpn_ccl" //
allHostSecret "vpn_mvd" //
allHostSecret "wifi_client" //
allHostSecret "clevis"
