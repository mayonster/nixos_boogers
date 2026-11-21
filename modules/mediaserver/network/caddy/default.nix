{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mediaServer.caddy;
  secrets = config.security.nix-secrets.secrets;
in {
  options = {
    homelab.services.caddy = {
      enable = lib.mkEnableOption "Enable caddy reverse proxy";
    };
  };

  config = lib.mkIf cfg.enable {
    #NOTE: Needs to be open for reverse proxy
    # Dont need to port forward if you don't want tho
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.caddy = {
      enable = true;
      environmentFile = secrets."env/caddy".path;

      package = pkgs.caddy.withPlugins {
        plugins = [
          # WARNING: Caddy is PINNED to v.0.2.4
          "github.com/caddy-dns/cloudflare@v0.2.4"
        ];
        # TODO: This hash will change whenever caddy OR caddy-cloduflared is updated
        # You're build will fail and tell you the expected hash (below) and then the
        # hash that it actually got. Copy it and change the one below when that happens
        hash = "sha256-QSiwKqKvSxhksWBF4/MlBOpyXba5xOQ2sRwA0R7399E=";
      };
      logFormat = lib.mkForce "level  INFO";
      globalConfig = ''
        acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        tls_resolvers 1.1.1.1
      '';
      #NOTE: Added a little sauce to disable external access if you want
      extraConfig = ''
        (internal_only) {
          @external {
            not remote_ip 192.168.0.0/16 10.0.0.0/8 172.16.0.0/12 100.64.0.0/10 127.0.0.1
          }
          abort @external
        }
      '';
    };
  };
}
