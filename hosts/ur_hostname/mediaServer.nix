{config, ...}: {
  config = {
    mediaServer = {
      baseDomain = "kauffizcool.com";
      user = "share";
      group = "share";
      enable = true;
      timeZone = "America/New_York";

      tailscale = {
        enable = true;
      };
      caddy = {
        enable = true;
      };
      jellyfin = {
        enable = true;
        url = "jf.${config.mediaServer.baseDomain}";
      };
    };
  };
}
