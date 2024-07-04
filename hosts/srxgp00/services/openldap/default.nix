{ pkgs, config, ... }:
let
  domain = "srx.digital";
  host = "ldap.${domain}";
  adminUser = "service";
  testUser = "hans";
  # domainSet = lib.splitString "." domain;
  # domainTLD = lib.lists.last domainSet;
  # domainSLD = lib.lists.last (lib.lists.reverseList domainSet);
  # distinguishedName = "dc=${domainSLD},dc=${domainTLD}";
  distinguishedName = "dc=srx,dc=digital";
  bindDnAdmin = "cn=${adminUser},${distinguishedName}";
in
{
  age.secrets = {
    ldapConfigSecret = {
      file = ./ldap-config-secret.age;
      owner = "openldap";
    };

    ldapBindSecret = {
      file = ./ldap-bind-secret.age;
      owner = "openldap";
    };
  };

  services.openldap = {
    enable = true;
    urlList = [
      "ldaps://"
      "ldapi://"
    ];
    configDir = "/var/lib/openldap/slapd.d";
    settings = {
      attrs = {
        olcReferral = "ldap://${host}";
        olcLogLevel = [ "stats" ];
        olcSecurity = "ssf=128";
        olcTLSProtocolMin = "3.3";
        olcTLSCipherSuite = "ECDHE-RSA-AES256-SHA384:AES256-SHA256:!RC4:HIGH:!MD5:!EDH:!EXP:!SSLV2:!eNULL";
        olcTLSCACertificateFile = "${config.security.acme.certs.${host}.directory}/fullchain.pem";
        olcTLSCertificateKeyFile = "${config.security.acme.certs.${host}.directory}/key.pem";
        olcTLSCertificateFile = "${config.security.acme.certs.${host}.directory}/chain.pem";
      };
      children = {
        "cn=schema".includes = [
          "${pkgs.openldap}/etc/schema/core.ldif"
          "${pkgs.openldap}/etc/schema/cosine.ldif"
          "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
          "${pkgs.openldap}/etc/schema/dyngroup.ldif"
          "${pkgs.openldap}/etc/schema/namedobject.ldif"
          "${pkgs.openldap}/etc/schema/nis.ldif"
        ];
        "olcDatabase={0}config" = {
          attrs = {
            objectClass = "olcDatabaseConfig";
            olcDatabase = "{0}config";
            olcAccess = [ "{0}to * by * none break" ];
          };
        };
        "olcDatabase={-1}frontend" = {
          attrs = {
            objectClass = "olcDatabaseConfig";
            olcDatabase = "{-1}frontend";
            olcAccess = [
              "{0}to * by dn.exact=uidNumber=0+gidNumber=0,cn=peercred,cn=external,cn=auth manage stop by * none stop"
            ];
          };
        };
        "olcDatabase={2}monitor" = {
          attrs = {
            objectClass = "olcMonitorConfig";
            olcDatabase = "{2}Monitor";
          };
        };
        "olcDatabase={1}mdb" = {
          attrs = {
            objectClass = [
              "olcDatabaseConfig"
              "olcMdbConfig"
            ];
            olcDatabase = "{1}mdb";
            olcDbDirectory = "${config.services.openldap.configDir}";
            olcDbIndex = [
              "objectClass eq"
              "cn pres,eq"
              "uid pres,eq"
              "sn pres,eq,subany"
            ];
            olcSuffix = distinguishedName;
            olcRootDN = bindDnAdmin;
            olcRootPW.path = "${config.age.secrets.ldapBindSecret.path}";
          };
        };
      };
    };
    declarativeContents = {
      ${distinguishedName} = ''
        dn: ${distinguishedName}
        objectClass: top
        objectClass: dcObject
        objectClass: organization
        o: ${domain}

        dn: ou=posix,${distinguishedName}
        objectClass: top
        objectClass: organizationalUnit

        dn: ou=accounts,ou=posix,${distinguishedName}
        objectClass: top
        objectClass: organizationalUnit

        dn: uid=${testUser},ou=accounts,ou=posix,${distinguishedName}
        objectClass: person
        objectClass: posixAccount
        userPassword: somePasswordHash
        homeDirectory: /home/${testUser}
        uidNumber: 1234
        gidNumber: 1234
        cn: ""
        sn: ""
      '';
    };
  };

  security.acme.certs."${host}" = {
    domain = "${host}";
    inherit (config.services.openldap) group;
    reloadServices = [ config.services.openldap.group ];
  };

  security.dhparams.enable = true;
}
