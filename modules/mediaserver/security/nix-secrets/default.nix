{config, ...}: let
  keys = config.keys;
  user = builtins.elemAt config.systemSettings.users 0;
in {
  config = {
    security.nix-secrets = {
      enable = true;
      storage = ../../../../secrets;
      storagePath = "/home/${user}/.config/nixos_boogers/secrets";
      #WARNING: Need ur identity paths here
      # If using mine, place the identities at these paths
      identityPaths = [
        "/home/${user}/.age/keys.txt"
        "/home/${user}/.ssh/id_ed25519"
      ];
      recipientAliases = {
        #leah = keys.leah.ssh;
        ur_host = keys.ur_host.age;
      };
    };
    security.rtkit.enable = true;
  };
}
