{ config, lib, pkgs, ... }:
let inherit (lib) types mkIf mkDefault mkOption;
in {
  options.my-config = {
    template.desktop.gnome.enable = mkOption {
      description = "Enable my customized GNOME desktop";
      type = types.bool;
      default = false;
    };
  };

  users.users.jer = {
    isNormalUser = true;
    home = "/home/jer";
    description = "Jeri V. Luckenbaugh";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPN0rcHxQVA3/ItRzxhd5eUmIzlUPihAPEP4zkQ/n7Oi jluckenbaugh@ucsd.edu" ];
    initialHashedPassword = "$6$b9oWhqTmy5w/DNyQ$NjzLIEB9n/i0aGzo5nKlP0kgxUORUgkY4bxdfsfAevFtBsMNhKJI3HIMmitq9tQfdrGTVdRa7PrP7CCSoUjh6/";
  };
  # if my-config.template.desktop.gnome.enable is set to true
  # set the following options
  config = mkIf config.my-config.template.desktop.gnome.enable {
    services.xserver = {
      enable = true;
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;
    };

    # GNOME must be used with a non-root user,
    # add a non-root user
    users.users.alice = {
      # Generate hashed password with "mkpasswd -m sha-512" command,
      # "!" disables login.
      # "mkpasswd" without "-m sha-512" will not work
      initialHashedPassword = "!";
      description = "Full Name";
      # Users in "wheel" group are allowed to use "doas" command
      # to obtain root permissions.
      extraGroups = [ "wheel" ];
      packages = builtins.attrValues {
        inherit (pkgs)
          mg # emacs-like editor
          jq # other programs
        ;
      };
      isNormalUser = true;
    };
    home-manager.users.alice = {
      home.packages =
        builtins.attrValues { inherit (pkgs) mg shellcheck _7zz; };

      gtk = {
        enable = true;
        font = { name = "sans-serif"; };
        theme = {
          name = "Adwaita";
          package = pkgs.gnome.gnome-themes-extra;
        };
        iconTheme = {
          package = pkgs.gnome.adwaita-icon-theme;
          name = "Adwaita";
        };
      };
    };

  };

}
