{
  config,
  pkgs,
  ...
}: let
  keys = config.keys;
  secrets = config.security.nix-secrets.secrets;
  port = 51820;
in {
  networking.firewall.allowedUDPPorts = [port];
  networking.nat = {
    enable = true;
    enableIPv6 = false;
    #WARNING: Change this external interface to yours
    externalInterface = "enp0s20f0u6";
    internalInterfaces = ["wg0"];
  };

  #NOTE: This sets up a wireguard proxy you can use on ur phone if you want
  # It also sets up the phone as a peer
  # You'd add NordVPN as a peer with the wireguard config you can download with ur account
  # There's a way to bind the systemd service to that VPN as well, I can help you with that I think
  # The first time you successfully build this host, you gotta run the wireguard script I gave you
  # The module doesn't do that automatically for whatever reason
  # wg-quick does, but it doesn't start the wireguard connection automatically which you will want
  networking.wireguard = {
    enable = true;
    interfaces = {
      wg0 = {
        ips = ["10.69.0.1/24"];
        listenPort = port;
        privateKeyFile = secrets."wireguard/evie".path;

        postSetup = ''
          ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.69.0.1/24 -o enp0s20f0u6 -j MASQUERADE
        '';

        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.69.0.1/24 -o enp0s20f0u6 -j MASQUERADE
        '';

        peers = [
          {
            name = "phone";
            publicKey = keys.ur_host.wireguard;
            allowedIPs = ["10.69.0.2/32"];
            #end point not needed since this peer is inbound only
          }
        ];
      };
    };
  };
}
