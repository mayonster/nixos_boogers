{
  config,
  lib,
  ...
}: let
  cfg = config.systemSettings.security.sshd;
  keys = config.keys;
  user = builtins.elemAt config.systemSettings.users 0;
in {
  options = {
    systemSettings.security.sshd = {
      enable = lib.mkEnableOption "Enable incoming ssh connections";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable incoming ssh
    services.openssh = {
      enable = true;
      openFirewall = true;
      #WARNING: Make sure you fill out ur public key
      # This disables password auth for ssh
      # You can undo that but like its so easy don't do it
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        KbdInteractiveAuthentication = false;
      };
    };
    programs.ssh.startAgent = true;
    # Don't forget to set:
    users.users.${user}.openssh.authorizedKeys.keys = [
      keys.ur_host.ssh
    ];
  };
}
