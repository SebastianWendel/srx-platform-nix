{ lib, ... }:
{
  resource = {
    keycloak_realm.srx-digital = {
      enabled = true;

      realm = "srx-digital";
      display_name = "SRX Digital - Development & Operations";
      login_theme = "keycloak";
      access_code_lifespan = "1h";
      display_name_html = "<b>SRX Digital - Development & Operations</b>";

      internationalization = [{
        default_locale = "en";
        supported_locales = [ "en" "de" ];
      }];

      verify_email = true;
      reset_password_allowed = true;
      login_with_email_allowed = true;
      password_policy = "length(20) and upperCase(2) and digits(2) and specialChars(2) and notUsername and passwordHistory(10) and forceExpiredPasswordChange(90)";
      ssl_required = "external";

      smtp_server = [{
        host = lib.tfRef "var.EMAIL_HOST";
        port = lib.tfRef "var.EMAIL_PORT";
        from = lib.tfRef "var.EMAIL_NO_REPLY";
        from_display_name = lib.tfRef "var.COMPANY_HEADER";
        reply_to = lib.tfRef "var.EMAIL_BILLING";
        reply_to_display_name = lib.tfRef "var.COMPANY_HEADER";
        auth = {
          username = lib.tfRef "var.EMAIL_NO_REPLY";
          password = lib.tfRef "var.EMAIL_PASSWORD";
        };
        ssl = true;
      }];

      security_defenses = [{
        headers = [{
          content_security_policy = "frame-src 'self'; frame-ancestors 'self'; object-src 'none';";
          content_security_policy_report_only = "";
          strict_transport_security = "max-age=31536000; includeSubDomains";
          x_content_type_options = "nosniff";
          x_frame_options = "DENY";
          x_robots_tag = "none";
          x_xss_protection = "1; mode=block";
        }];

        brute_force_detection = [{
          failure_reset_time_seconds = 43200;
          max_failure_wait_seconds = 900;
          max_login_failures = 30;
          minimum_quick_login_wait_seconds = 60;
          permanent_lockout = false;
          quick_login_check_milli_seconds = 1000;
          wait_increment_seconds = 60;
        }];
      }];
    };

    keycloak_openid_client = {
      openid_client = {
        enabled = true;
        client_id = "code";
        name = "SRX Code Base ";
        access_type = "CONFIDENTIAL";
        standard_flow_enabled = true;
        valid_redirect_uris = [ "https://code.srx.digital/*" ];
        realm_id = "\${keycloak_realm.srx-digital.id}";
      };
    };

    keycloak_group.operator = {
      name = "operator";
      realm_id = "\${keycloak_realm.srx-digital.id}";
      depends_on = [
        "keycloak_realm.srx-digital"
      ];
    };

    keycloak_user.swendel = {
      enabled = true;
      username = "swendel";
      first_name = "Sebastian";
      last_name = "Wendel";
      email = lib.tfRef "var.EMAIL_PERSONAL";

      required_actions = [
        "Verify email"
        "Update profile"
        "Update password"
        "Configure OTP"
      ];

      initial_password = {
        value = lib.tfRef "var.EMAIL_PERSONAL";
        temporary = true;
      };

      realm_id = "\${keycloak_realm.srx-digital.id}";

      depends_on = [
        "keycloak_realm.srx-digital"
        "keycloak_group.operator"
      ];
    };

    keycloak_user_groups.operator = {
      user_id = "\${keycloak_user.swendel.id}";
      group_ids = [ "\${keycloak_group.operator.id}" ];
      realm_id = "\${keycloak_realm.srx-digital.id}";
    };
  };
}
