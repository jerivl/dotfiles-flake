# configuration in this file only applies to edith host
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
      bootDevices = [  "ata-Patriot_P210_2048GB_PBEADBB2211180481" "ata-Patriot_P210_2048GB_PBEADBB2211180518" "ata-Patriot_P210_2048GB_PBEADBB2211180345" "ata-Patriot_P210_2048GB_PBEADBB2211180531" ];
      immutable = false;
      availableKernelModules = [  "ahci" "ohci_pci" "ehci_pci" "pata_atiixp" "xhci_pci" "firewire_ohci" "usbhid" "usb_storage" "sd_mod" ];
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
      hostName = "edith";
      timeZone = "Europe/Berlin";
      hostId = "b5fd399a";
    };
  };

  # To add more options to per-host configuration, you can create a
  # custom configuration module, then add it here.
  my-config = {
    # Enable custom gnome desktop on edith
    template.desktop.gnome.enable = false;
  };
}
