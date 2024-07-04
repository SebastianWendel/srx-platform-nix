{ config, pkgs, ... }:
{
  age.secrets = {
    resticRepoKey = {
      file = ./repo_key.age;
      group = "crstl";
      mode = "0440";
    };

    resticRepoSsh = {
      file = ./repo_ssh.age;
      group = "crstl";
      mode = "0440";
    };
  };

  services.restic.backups.srxnb00_crstl = {
    initialize = true;
    repository = "sftp:automat@srxnas01.vpn.srx.dev:/srv/backups/restic/srxnb00_crstl";
    passwordFile = config.age.secrets.resticRepoKey.path;
    extraOptions = [
      "sftp.command='ssh -i ${config.age.secrets.resticRepoSsh.path} automat@srxnas01.vpn.srx.dev -s sftp'"
    ];
    paths = [
      "/etc"
      "/home/crstl/.age"
      "/home/crstl/.config"
      "/home/crstl/.gnupg"
      "/home/crstl/.mozilla"
      "/home/crstl/.password-store"
      "/home/crstl/.pki"
      "/home/crstl/.ssh"
      "/home/crstl/.thunderbird"
      "/home/crstl/Development"
      "/home/crstl/Documents"
      "/home/crstl/Pictures"
    ];
    exclude = [
      "/home/crstl/.cache"
      "/home/crstl/.cargo"
      "/home/crstl/.conda"
      "/home/crstl/.kube/cache"
      "/home/crstl/.local"
      "/home/crstl/.npm"
      "/home/crstl/.npm"
      "/home/crstl/.npm-global"
      "/home/crstl/.phoronix-test-suite"
      "/home/crstl/.torrent"
      "/home/crstl/Downloads"
      "/home/crstl/Music"
      "/home/crstl/Nextcloud"
      "/home/crstl/Videos"
    ];
    checkOpts = [ "--with-cache" ];
    timerConfig = {
      Persistent = true;
      OnCalendar = "daily";
      RandomizedDelaySec = "5h";
    };
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 1"
    ];
  };

  environment.systemPackages = with pkgs; [ restic ];
}
