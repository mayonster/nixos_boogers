{config, ...}: let
  dots = "${../../../dotfiles}";
  user = builtins.elemAt config.systemSettings.users 0;
in {
  #NOTE: I left this as an example
  # You don't necessarily need it but also don't fall for home-manager propaganda
  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_STATE_HOME = "$HOME/.local/state";
  };
  hjem.users.${user} = {
    impure = {
      enable = true;
      dotsDir = dots;
      dotsDirImpure = "/home/${user}/.config/nixos-config/dotfiles";
    };
    directory = "/home/${user}";
    #Overwrite generated configs
    clobberFiles = true;
    # Pure setup
    xdg.config.files = {
      # dotfiles
      "yazi".source = dots + "/yazi";
    };
    xdg.mime-apps = {
      default-applications = {
        "application/zip" = "7z";
      };
    };
  };
}
