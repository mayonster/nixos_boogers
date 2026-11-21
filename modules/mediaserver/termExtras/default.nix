{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.systemSettings.termExtras;
  user = builtins.elemAt config.systemSettings.users 0;
in {
  options = {
    systemSettings.termExtras = {
      enable = lib.mkEnableOption "Enable extras for the terminal";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.fastfetch
      pkgs.killall
      pkgs.btop
      pkgs.ripgrep
      pkgs.fzf
      pkgs.p7zip-rar
      pkgs.stylua
      pkgs.age
      pkgs.unrar-wrapper
    ];

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/${user}/.config/nixos_boogers";
    };
  };
}
