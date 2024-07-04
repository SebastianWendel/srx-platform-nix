{ config, pkgs, ... }:
{
  age.secrets = {
    resticRepoKey.file = ./repo_key.age;
    resticRepoSsh.file = ./repo_ssh.age;
  };

  environment.systemPackages = with pkgs; [ restic ];

  services.restic.backups.base = {
    paths = [ "/var/lib" "/var/backup" ];
    exclude = [ "/var/lib/prometheus2" ];
    repository = "sftp:u388681@u388681.your-storagebox.de:/home";
    passwordFile = config.age.secrets.resticRepoKey.path;
    extraOptions = [ "sftp.command='ssh -p 23 -i /run/agenix/resticRepoSsh u388681@u388681.your-storagebox.de -s sftp'" ];
    initialize = true;
    checkOpts = [ "--with-cache" ];
    timerConfig.OnCalendar = "04:00";
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 1"
    ];
  };

  home-manager.users.root.home.sessionVariables = {
    RESTIC_PASSWORD_FILE = config.age.secrets.resticRepoKey.path;
    RESTIC_REPOSITORY = config.services.restic.backups.base.repository;
  };
}
