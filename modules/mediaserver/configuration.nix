{
  config,
  lib,
  ...
}: {
  config = {
    # Journal
    services.journald.settings.Journal = {
      SystemMaxUse = "50M";
      SystemMaxFiles = 5;
      rateLimitBurst = 500;
      rateLimitInterval = "30s";
    };
    #services.journald.rateLimitBurst = 500;
    #services.journald.rateLimitInterval = "30s";

    # Locale and TimeZone
    time.timeZone = "America/New_York";
    services.timesyncd.enable = true;

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = config.i18n.defaultLocale;
      LC_IDENTIFICATION = config.i18n.defaultLocale;
      LC_MEASUREMENT = config.i18n.defaultLocale;
      LC_MONETARY = config.i18n.defaultLocale;
      LC_NAME = config.i18n.defaultLocale;
      LC_NUMERIC = config.i18n.defaultLocale;
      LC_PAPER = config.i18n.defaultLocale;
      LC_TELEPHONE = config.i18n.defaultLocale;
      LC_TIME = config.i18n.defaultLocale;
    };

    # WARNING: You will have to remove the github PAT before you build
    # I left it in place to show you how to add it again for using tack
    # And circus if you so choose to go down the CI route
    # Ensure nix flakes are enabled
    nix.extraOptions = ''
      experimental-features = nix-command flakes
      !include ${config.security.nix-secrets.secrets."alfk99/github_token".path}
    '';

    # Wheel group gets trusted access to nix daemon
    nix.settings.trusted-users = ["@wheel" "remotebuild"];

    # Bootloader
    # Systemd-boot if uefi, default to grub otherwise
    # May change to re-Find since i liked it better
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.editor = false;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";

    # May enable this later, but i kinda like the cluttered logs
    # Silent boot
    # boot.kernelParams = [
    # "quiet"
    # "splash"
    # "vga=current"
    # "rd.systemd.show_status=false"
    # "rd.udev.log_level=3"
    # "udev.log_priority=3"
    # boot.intitrd.systemd.enable = true;
    # boot.initrd.verbose = false;
    # boot.plymouth.enable = true;

    # Networking
    # Use network manager because nmcli goes nuts
    networking.networkmanager.enable = true;

    # Remove bloat ;)
    programs.nano.enable = lib.mkForce false;

    # Localsend for setting up new systems or quickly transferring files
    programs.localsend.enable = true;
    programs.localsend.openFirewall = true;
  };
}
