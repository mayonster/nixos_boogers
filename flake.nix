{
  description = "mayonster's flake";

  outputs = {self, ...} @ args: let
    #NOTE: I use tack over the stock flake inputs system
    # you can totally change if you want but I highly recommend
    # inputs are in .tack/pins.toml
    inputs = (import ./.tack) {overrides = args.tackOverrides or {};};

    #NOTE: You will need lib at some point, even if you don't know it yet
    # Configure lib
    lib = inputs.nixpkgs.lib;

    #NOTE: Create a list of all hosts inside of ./hosts
    #WARNING: change your hostname to be what you want in /hosts
    hosts = builtins.filter (x: x != null) (
      lib.mapAttrsToList (name: value:
        if (value == "directory")
        then name
        else null) (
        builtins.readDir ./hosts
      )
    );
  in {
    # Generate a nixos config for every host in ./hosts
    nixosConfigurations = builtins.listToAttrs (
      map (host: {
        name = host;
        value = lib.nixosSystem {
          modules = [
            # Configs per each host
            {config.networking.hostName = host;}
            (./hosts + "/${host}")

            # Modules
            ./modules/mediaserver

            #NOTE: You don't necessarily need this
            # See modules/mediaserver/hjem.nix for explanation
            # Add hjem!
            inputs.hjem.nixosModules.default
            # AND Impure!
            {
              hjem.extraModules = [inputs.hjem-impure.hjemModules.default];
            }

            #NOTE: You can also choose sops or agenix
            # You will have to write that urself if you do
            # Add nix-secrets
            inputs.nix-secrets.nixosModules.default
          ];
          specialArgs = {
            inherit inputs;
          };
        };
      })
      hosts
    );
  };
}
