{
  lib,
  config,
  ...
}: let
  cfg = config.systemSettings.security.gpg;
in {
  options = {
    systemSettings.security.gpg = {
      enable = lib.mkEnableOption "Enable gpg";
    };
  };

  config = lib.mkIf cfg.enable {
    #NOTE: I need gnupg for my yubikey, but not the agent
    # Leaving again as an example
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
    };
  };
}
