{ pkgs, ... }:
let
  ipxeDerivation = pkgs.ipxe.overrideDerivation (_drv: {
    additionalOptions = [
      "KEYBOARD_MAP"
      "NET_PROTO_IPV6"
      "DOWNLOAD_PROTO_NFS"
      "DOWNLOAD_PROTO_FTP"
      "DOWNLOAD_PROTO_FILE"
      "DOWNLOAD_PROTO_HTTPS"
      "CONSOLE_FRAMEBUFFER"
      "CONSOLE_SERIAL"
      "CONSOLE_SYSLOG"
      "IMAGE_TRUST_CMD"
      "IMAGE_ARCHIVE_CMD"
      "IMAGE_ZLIB"
      "IMAGE_GZIP"
      "IMAGE_SCRIPT"
      "IMAGE_PNG"
      "CERT_CMD"
      "CONSOLE_CMD"
      "DIGEST_CMD"
      "IMAGE_MEM_CMD"
      "IPSTAT_CMD"
      "NEIGHBOUR_CMD"
      "NSLOOKUP_CMD"
      "NTP_CMD"
      "PARAM_CMD"
      "PCI_CMD"
      "POWEROFF_CMD"
      "PXE_CMD"
      "TIME_CMD"
      "VLAN_CMD"
    ];
  });
in
{
  networking.firewall = {
    allowedUDPPorts = [ 69 ];
    allowedTCPPorts = [ 69 ];
  };

  services.atftpd = {
    enable = true;
    root = ipxeDerivation;
  };
}
