{ inputs, config, ... }:
with config.srx.service.dns;
with inputs.dns.lib.combinators;
{
  srx.service.dns.zones."curious.bio" = {
    inherit (defaults) SOA NS TTL TXT DMARC;

    MX = [ (mx.mx 10 "mail.curious.bio.") ];

    DKIM = [{
      selector = "mail";
      s = [ "email" ];
      p = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDhbKGSt4MB4B0KBZNLb7Kz0/NJNhRceSRNlgeWe41jwB19uyks/q3Mk+7xFfs/yNIzDc0RuzGZoMAFuALpYsYiRAUV5f/PRgM/a2fCQ0f3aWWTAMT8ieZhHfOYPqnYV0cxCeYnbNbIgeT2Fic8GhRWpiPxDWqIC2zil09nmb2iTwIDAQAB";
    }];

    A = [ "116.202.240.209" ];
    AAAA = [ "2a01:4f8:241:3e69::1" ];

    SRV = [
      {
        service = "caldavs";
        proto = "tcp";
        port = 443;
        target = "cloud";
      }
      {
        service = "carddavs";
        proto = "tcp";
        port = 443;
        target = "cloud";
      }
    ];

    subdomains = rec {
      copepod = host "116.202.240.209" "2a01:4f8:241:3e69::1";

      mail = copepod;
      autoconfig = copepod;

      id = copepod;
      track = copepod;

      www = copepod;
      code = copepod;
      wiki = copepod;
      pad = copepod;
      office = copepod;
      survey = copepod;
      paper = copepod;

      cloud = copepod;
      onlyoffice = copepod;
      collabora = copepod;

      meet = copepod;
      "recordings.meet" = copepod;

      pretix = copepod;
      ticket = copepod;
      events = copepod;

      forum = copepod;
      media = copepod;
      social = copepod;
      images = copepod;

      matrix = copepod;
      matrix-admin = copepod;
      chat = copepod;
      turn = copepod;

      status = copepod;

      flow = copepod;
      dashboard = copepod;
      mqtt = copepod;
      tsdb = copepod;
      alarm = copepod;

      oh4k.CNAME = [ "oh4k.lupus-ddns.de." ];
      diatome.CNAME = [ "oh4k" ];

      iot.subdomains = {
        control = copepod;
        flow = copepod;
        net = copepod;
        api = copepod;
        mqtt = copepod;
      };

      vpn.subdomains = {
        copepod = host "10.80.1.1" null;
        diatome = host "10.80.1.50" null;
      };

      "usr.hq.hh".subdomains = {
        cclap00.A = [ "10.10.0.4" ];
        cclfw00.A = [ "10.10.0.1" ];
        diatome.A = [ "10.10.0.2" ];
        ccllp00.A = [ "10.10.0.70" ];
        cclsw00.A = [ "10.10.0.3" ];
        cclws00_ipmi.A = [ "10.10.0.12" ];
        cclws00.A = [ "10.10.0.11" ];
        davis-gw.A = [ "10.10.0.87" ];
        fablab-gw.A = [ "10.10.0.82" ];
        homematic-gw.A = [ "10.10.0.5" ];
        janitza.A = [ "10.10.0.90" ];
        kimo-c310.A = [ "10.10.0.6" ];
        lupus-cam-entry.A = [ "10.10.0.86" ];
        lupus-cam-social.A = [ "10.10.0.83" ];
        lupus-cam-tor.A = [ "10.10.0.84" ];
        lupus-cam-ws.A = [ "10.10.0.85" ];
        lupus-gw.A = [ "10.10.0.81" ];
      };

      "gh.hq.hh".subdomains = {
        vermiloop.A = [ "10.10.60.11" ];
      };
    };
  };
}
