{
  postfix_queue_length = {
    condition = "avg_over_time(postfix_queue_length[1h]) > 10";
    description = "{{$labels.instance}}: postfix mail queue has undelivered {{$value}} items";
  };

  # https://doc.dovecot.org/configuration_manual/stats/old_statistics/
  # dovecot_up
  # dovecot_user_auth_failures
  # dovecot_user_auth_db_tempfails
}
