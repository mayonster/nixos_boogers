{...}: {
  # Make it so usb autosuspent is disabled
  boot.kernelParams = ["usbcore.autosuspend=-1"];

  # Change umask so allegedy i wont have issues with permissions on newly downloaded files
  security.pam.enableUMask = true;
  security.loginDefs.settings.UMASK = "002";

  #WARNING: obviously this will need to change, but this is how you can automount external volumes
  # Setup the 2TB HDD
  fileSystems."/mnt/data1" = {
    device = "/dev/disk/by-uuid/";
    fsType = "btrfs";
    options = [
      "users"
      "nofail"
      "exec"
      "compress=zstd"
    ];
  };

  # Setup NFS for the drives
  # Only need to export the data subvolume
  # Snapshots will be handled on the server itself
  # Export virtual root directory thru bind mounts
  # Considered best practice
  fileSystems."/export/bigdisk" = {
    device = "/mnt/data1/data";
    fsType = "none";
    options = ["bind"];
  };

  #NOTE: I use NFS personally but samba is also valid
  # Enable NFS
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /export         10.0.0.0/24(rw,insecure,fsid=12345,no_subtree_check,crossmnt,all_squash)
    /export/bigdisk 10.0.0.0/24(rw,nohide,insecure,no_subtree_check,crossmnt,all_squash)
  '';

  # Allow NFS traffic through the firewall
  networking.firewall.allowedTCPPorts = [2049];

  #NOTE: I use USB drives that unmount if they go to sleep
  # I need the keepalive script to prevent that
  # If using actual drives, remove this
  # Keep these mfs alive
  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/5 * * * *   root   touch /mnt/data1/keepalive &>/dev/null"
    ];
  };
}
