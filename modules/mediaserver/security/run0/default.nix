{
  config,
  lib,
  ...
}: let
  cfg = config.systemSettings.security.run0;
in {
  options = {
    systemSettings.security.run0 = {
      enable = lib.mkEnableOption "Enable run0 in place of sudo/doas";
    };
  };

  # WARNING: run0 in place of plain sudo trust
  config = lib.mkIf cfg.enable {
    security = {
      run0 = {
        enable = true;
        sudo-shim.enable = true;
        persistentAuth = {
          enable = true;
          enableRemote = true;
        };
      };
      sudo.enable = false;
    };
  };
}
