{lib, ...}: {
  options = {
    keys = {
      ur_host = {
        ssh = lib.mkOption {
          default = "";
          type = lib.types.str;
          description = "ur_host's PUBLIC ssh key";
        };
        age = lib.mkOption {
          default = "";
          type = lib.types.str;
          description = "ur_host's PUBLIC age key";
        };
        wireguard = lib.mkOption {
          default = "";
          type = lib.types.str;
          description = "ur_hosts PUBLIC wireguard key";
        };
      };
    };
  };
}
