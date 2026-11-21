{
  config,
  lib,
  ...
}: let
  cfg = config.systemSettings.vim;
in {
  options = {
    systemSettings.vim = {
      enable = lib.mkEnableOption "enable vim";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
