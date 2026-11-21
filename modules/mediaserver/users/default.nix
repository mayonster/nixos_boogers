{
  config,
  lib,
  ...
}: {
  options = {
    systemSettings = {
      users = lib.mkOption {
        description = "List of desktop users to create on the system";
        type = lib.types.listOf lib.types.str;
      };
      adminUsers = lib.mkOption {
        description = "List of desktop users to grant admin (sudo) access on the system";
        type = lib.types.listOf lib.types.str;
      };
    };
  };
  config = {
    users.groups =
      builtins.listToAttrs
      (map (user: {
          name = user;
          value = {
            name = user;
          };
        })
        config.systemSettings.users);

    users.users =
      builtins.listToAttrs
      (map (user: {
          name = user;
          value = {
            isNormalUser = true;
            extraGroups = ["networkmanager" "input" "docker" "remotebuild"] ++ (lib.optionals (lib.any (x: x == user) config.systemSettings.adminUsers) ["wheel"]);
            createHome = true;
            linger = true;
            group = user;
          };
        })
        config.systemSettings.users);
  };
}
