{
  services.home-assistant.lovelaceConfig = {
    title = "SRX";
    views = [
      {
        title = "Overview";
        cards = [
          {
            type = "markdown";
            content = ''
              https://srx.digital
            '';
          }
        ];
      }
    ];
  };
}
