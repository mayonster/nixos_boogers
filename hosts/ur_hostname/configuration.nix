{pkgs, ...}: {
  config = {
    #SECTION: Distributed builds

    #NOTE: This is some faciness you can pull off if you run ur pc on nix too
    # If you don't do that, then delete this
    # It will pop warning on build for like no reason
    # If you do use it, you need a ssh key for root in the BUILDER
    nix.buildMachines = [
      {
        hostName = "ur_builder";
        sshUser = "remotebuild";
        sshKey = "/root/.ssh/remotebuild";
        system = pkgs.stdenv.hostPlatform.system;
        maxJobs = 3;
        speedFactor = 2;
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
      }
    ];
    nix.distributedBuilds = true;
    nix.settings = {
      builders-use-substitutes = true;
    };
    # This is how you get xterm-kitty on a headless host if u use kitty
    # Need xterm-kitty for systemctl and journalctl outputs
    environment.systemPackages = [
      pkgs.kitty
    ];
    systemSettings = {
      # Setup the users
      users = ["alfk99"];
      adminUsers = ["alfk99"];

      git.enable = true;

      # Editor
      vim.enable = true;

      #Fonts
      #Needed for proper nvim
      fonts.enable = true;

      termExtras.enable = true;

      # File Management
      yazi.enable = true;

      # Security
      security = {
        automount.enable = true;
        #blocklist.enable = true;
        run0.enable = true;
        #firejail.enable = false;
        gpg.enable = true;
        firewall.enable = true;
        sshd.enable = true;
      };
    };
    nixpkgs.config.allowUnfree = true;
  };
}
