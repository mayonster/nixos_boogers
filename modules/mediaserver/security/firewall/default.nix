{
  config,
  lib,
  ...
}: let
  cfg = config.systemSettings.security.firewall;
in {
  options = {
    systemSettings.security.firewall = {
      enable = lib.mkEnableOption "Activate firewall with open port for openssh ONLY";
    };
  };

  config = lib.mkIf cfg.enable {
    # Firewall
    networking.firewall.enable = true;
    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [22];
  };
}
