{ config, ... }:
with config.srx.service.dns;
{
  srx.service.dns.zones."sourceindex.de" = {
    inherit (defaults) SOA NS TTL MX TXT DMARC A AAAA;

    DKIM = [{
      selector = "mail";
      s = [ "email" ];
      p = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDM6qdnkgI0+PxDG63mON8gBjvN3GxW7HHkVMbjmG2rN72CFAuG5F3P9fAiocGWy1jN1mv9DhY3FNqdElE7ebxp3JnrLmKYHF4B5wmHSEmrTHeaVrc+Xnr/E2FWvcafTicOQXx1CRbDfHChH1As1RUFiL0HC0QQfXvXD0QTUzaq6QIDAQAB";
    }];
  };
}
