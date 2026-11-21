{
  config,
  lib,
  ...
}: let
  cfg = config.mediaServer.technitium;
  opts = config.mediaServer;
in {
  options = {
    mediaServer.technitium = {
      enable = lib.mkEnableOption "Enable technitium DNS server";
    };
  };

  #NOTE: This is is what I use for internal DNS
  # Don't need to use it but figured I'd put you on game

  config = lib.mkIf cfg.enable {
    services.technitium-dns-server = {
      enable = true;
      # Ports
      # 53: TCP and UDP for DNS
      # 5380, 53443: TCP, HTTP, HTTPS for web interface
      openFirewall = true;
    };
    services.caddy.virtualHosts."dns.${opts.baseDomain}" = {
      extraConfig = ''
        import internal_only
        reverse_proxy 127.0.0.1:5380
      '';
    };
  };
}
