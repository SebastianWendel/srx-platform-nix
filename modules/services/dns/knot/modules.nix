{
  services.knot.settings = {
    mod-rrl.default = {
      rate-limit = 512;
      slip = 2;
    };

    mod-cookies.default = {
      secret-lifetime = "30h";
      badcookie-slip = 3;
    };

    mod-stats.all = {
      server-operation = true;
      edns-presence = true;
      flag-presence = true;
      query-size = true;
      query-type = true;
      request-protocol = true;
      request-bytes = true;
      request-edns-option = true;
      reply-size = true;
      reply-nodata = true;
      response-code = true;
      response-bytes = true;
      response-edns-option = true;
    };
  };
}
