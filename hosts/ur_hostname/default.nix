{...}: {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./mediaServer.nix
    ./filesystems.nix
    ./secrets.nix
    ./wireguard.nix
  ];
}
