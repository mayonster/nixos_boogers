{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mediaServer.jellyfin;
  opts = config.mediaServer;
in {
  options = {
    mediaServer.jellyfin = {
      enable = lib.mkEnableOption {
        description = "Enable Jellyfin Streaming";
      };

      configDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/jellyfin";
      };

      url = lib.mkOption {
        type = lib.types.str;
        default = "jellyfin.${opts.baseDomain}";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # WARNING: You'll have to setup whatever ur encoding stuff is
    # Will be similar for plex but this is the player example
    # I don't personally use plex so can't fully help ya there
    # Set some intel bs
    nixpkgs.config.packageOverrises = pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCode = true;};
    };

    systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";
    environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-ocl
        intel-media-driver
        intel-compute-runtime-legacy1
      ];
    };

    services.jellyfin = {
      enable = true;
      # Need this for android tv apparently
      openFirewall = true;

      # Extras
      hardwareAcceleration = {
        enable = true;
        type = "vaapi";
        device = "/dev/dri/by-path/pci-0000:00:02.0-render";
      };
    };

    services.caddy.virtualHosts."${cfg.url}" = {
      extraConfig = ''
        import internal_only
        reverse_proxy http://127.0.0.1:8096
      '';
    };
  };
}
