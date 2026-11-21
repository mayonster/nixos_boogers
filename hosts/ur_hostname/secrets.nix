{...}: {
  security.nix-secrets.secrets = {
    "env/caddy" = {
      owner = "caddy";
      group = "caddy";
      recipients = ["evie" "lucy"];
    };
    "mayonster/github_token" = {
      owner = "ian";
      recipients = ["lucy" "evie" "veronica"];
    };
    "wireguard/evie" = {
      owner = "mayonster";
      recipients = ["lucy" "evie"];
    };
    #NOTE: Left this one since its in the module. Delete if you dont use
    "headplane/preAuthKey" = {
      recipients = ["lucy" "emma" "evie" "veronica"];
    };
  };
}
