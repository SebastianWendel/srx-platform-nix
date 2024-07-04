{
  variable = {
    COMPANY_HEADER = {
      type = "string";
    };

    USERNAME_PERSONAL = {
      type = "string";
      default = "guest";
    };

    USERNAME_ADMIN = {
      type = "string";
      default = "admin";
    };

    EMAIL_HOST = {
      type = "string";
      default = "mail.example.com";
    };

    EMAIL_PORT = {
      type = "number";
      default = 465;
    };

    EMAIL_PERSONAL = {
      type = "string";
      default = "guest@example.com";
    };

    EMAIL_PUBLIC = {
      type = "string";
      default = "no-reply@example.com";
    };

    EMAIL_BILLING = {
      type = "string";
      default = "no-reply@example.com";
    };

    EMAIL_NO_REPLY = {
      type = "string";
      default = "no-reply@example.com";
    };

    EMAIL_PASSWORD = {
      type = "string";
      sensitive = true;
    };

    GITHUB_TOKEN = {
      type = "string";
      sensitive = true;
    };
  };
}
