#onfiguration in this file only applies to eleanor host
#
# only my-config.* and zfs-root.* options can be defined in this file.
#
# all others goes to `configuration.nix` under the same directory as
# this file. 

{ system, pkgs, ... }: {
  inherit pkgs system;
  zfs-root = {
    boot = {
      devNodes = "/dev/disk/by-id/";
      bootDevices = [  "ata-SPCC_Solid_State_Disk_FEB407581E0802522469" "ata-KINGSTON_SUV500120G_50026B7782AD94D4" ];
      immutable = false;
      availableKernelModules = [  "ehci_pci" "ata_piix" "usb_storage" "usbhid" "sd_mod" ];
      removableEfi = true;
      kernelParams = [ ];
      sshUnlock = {
        # read sshUnlock.txt file.
        enable = false;
        authorizedKeys = [ ];
      };
    };
    networking = {
      # read changeHostName.txt file.
      hostName = "eleanor";
      timeZone = "Europe/Berlin";
      hostId = "ab847152";
    };
  };

  boot.zfs.extraPools = [ "e2pool" ];

  # To add more options to per-host configuration, you can create a
  # custom configuration module, then add it here.
  my-config = {
    # Enable custom gnome desktop on eleanor
    template.desktop.gnome.enable = false;
  };
}
