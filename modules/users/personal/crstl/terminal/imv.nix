{ lib, ... }:
{
  programs.imv = {
    enable = true;
    settings = {
      options.background = "ffffff";
      aliases.x = "close";
    };
  };

  xdg.mimeApps.defaultApplications = {
    "image/bmp" = lib.mkForce "imv.desktop";
    "image/gif" = lib.mkForce "imv.desktop";
    "image/jpeg" = lib.mkForce "imv.desktop";
    "image/jpg" = lib.mkForce "imv.desktop";
    "image/pjpeg" = lib.mkForce "imv.desktop";
    "image/png" = lib.mkForce "imv.desktop";
    "image/tiff" = lib.mkForce "imv.desktop";
    "image/webp" = lib.mkForce "imv.desktop";
    "image/x-3fr" = lib.mkForce "imv.desktop";
    "image/x-adobe-dng" = lib.mkForce "imv.desktop";
    "image/x-arw" = lib.mkForce "imv.desktop";
    "image/x-bay" = lib.mkForce "imv.desktop";
    "image/x-bmp" = lib.mkForce "imv.desktop";
    "image/x-canon-cr2" = lib.mkForce "imv.desktop";
    "image/x-canon-crw" = lib.mkForce "imv.desktop";
    "image/x-cap" = lib.mkForce "imv.desktop";
    "image/x-cr2" = lib.mkForce "imv.desktop";
    "image/x-crw" = lib.mkForce "imv.desktop";
    "image/x-dcr" = lib.mkForce "imv.desktop";
    "image/x-dcraw" = lib.mkForce "imv.desktop";
    "image/x-dcs" = lib.mkForce "imv.desktop";
    "image/x-dng" = lib.mkForce "imv.desktop";
    "image/x-drf" = lib.mkForce "imv.desktop";
    "image/x-eip" = lib.mkForce "imv.desktop";
    "image/x-erf" = lib.mkForce "imv.desktop";
    "image/x-fff" = lib.mkForce "imv.desktop";
    "image/x-fuji-raf" = lib.mkForce "imv.desktop";
    "image/x-iiq" = lib.mkForce "imv.desktop";
    "image/x-k25" = lib.mkForce "imv.desktop";
    "image/x-kdc" = lib.mkForce "imv.desktop";
    "image/x-mef" = lib.mkForce "imv.desktop";
    "image/x-minolta-mrw" = lib.mkForce "imv.desktop";
    "image/x-mos" = lib.mkForce "imv.desktop";
    "image/x-mrw" = lib.mkForce "imv.desktop";
    "image/x-nef" = lib.mkForce "imv.desktop";
    "image/x-nikon-nef" = lib.mkForce "imv.desktop";
    "image/x-nrw" = lib.mkForce "imv.desktop";
    "image/x-olympus-orf" = lib.mkForce "imv.desktop";
    "image/x-orf" = lib.mkForce "imv.desktop";
    "image/x-panasonic-raw" = lib.mkForce "imv.desktop";
    "image/x-pcx" = lib.mkForce "imv.desktop";
    "image/x-pef" = lib.mkForce "imv.desktop";
    "image/x-pentax-pef" = lib.mkForce "imv.desktop";
    "image/x-png" = lib.mkForce "imv.desktop";
    "image/x-portable-anymap" = lib.mkForce "imv.desktop";
    "image/x-portable-bitmap" = lib.mkForce "imv.desktop";
    "image/x-portable-graymap" = lib.mkForce "imv.desktop";
    "image/x-portable-pixmap" = lib.mkForce "imv.desktop";
    "image/x-ptx" = lib.mkForce "imv.desktop";
    "image/x-pxn" = lib.mkForce "imv.desktop";
    "image/x-r3d" = lib.mkForce "imv.desktop";
    "image/x-raf" = lib.mkForce "imv.desktop";
    "image/x-raw" = lib.mkForce "imv.desktop";
    "image/x-rw2" = lib.mkForce "imv.desktop";
    "image/x-rwl" = lib.mkForce "imv.desktop";
    "image/x-rwz" = lib.mkForce "imv.desktop";
    "image/x-sigma-x3f" = lib.mkForce "imv.desktop";
    "image/x-sony-arw" = lib.mkForce "imv.desktop";
    "image/x-sony-sr2" = lib.mkForce "imv.desktop";
    "image/x-sony-srf" = lib.mkForce "imv.desktop";
    "image/x-sr2" = lib.mkForce "imv.desktop";
    "image/x-srf" = lib.mkForce "imv.desktop";
    "image/x-tga" = lib.mkForce "imv.desktop";
    "image/x-x3f" = lib.mkForce "imv.desktop";
    "image/x-xbitmap" = lib.mkForce "imv.desktop";
  };
}
