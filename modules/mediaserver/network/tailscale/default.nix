{
  config,
  lib,
  ...
}: let
  cfg = config.mediaServer.tailscale;
  secrets = config.security.nix-secrets.secrets;
in {
  options = {
    mediaServer.tailscale = {
      enable = lib.mkEnableOption "Enable tailscale";
    };
  };
  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      #NOTE: This is a pre-shared key you can create for auto-login
      authKeyFile = "${secrets."headplane/preAuthKey".path}";
      #WARNING: this is how you connect to a self hosted one if ur into that
      # Remove this item if you just wanna use regular tailscale
      extraUpFlags = [
        "--login-server=https://kauffiscool.com"
      ];
    };
    networking.nftables.enable = true;
    networking.firewall = {
      trustedInterfaces = [config.services.tailscale.interfaceName];
      allowedUDPPorts = [config.services.tailscale.port];
    };

    systemd.services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];

    systemd.network.wait-online.enable = false;
    boot.initrd.systemd.network.wait-online.enable = false;
  };
}
