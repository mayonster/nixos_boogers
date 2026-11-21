{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mediaServer.git;
in {
  options = {
    mediaServer.git = {
      enable = lib.mkEnableOption "Enable git";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;
      config = {
        user = {
          name = "alfk99";
          email = "alfk99@gmail.com"; #WARNING: CHANGE THIS
        };
        init = {
          defaultBranch = "main";
        };
        safe = {
          directory = "/home/ian/.cache/nix/tarball-cache";
        };
      };
    };
    environment.systemPackages = [
      pkgs.git-extras
      pkgs.git-filter-repo
    ];
  };
}
