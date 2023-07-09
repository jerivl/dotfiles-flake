# configuration in this file is shared by all hosts

{ pkgs, ... }: {
  # Enable NetworkManager for wireless networking,
  # You can configure networking with "nmtui" command.
  networking.useDHCP = true;
  networking.networkmanager.enable = false;

  
  users.users = {
    root = {
      initialHashedPassword = "$6$jhFedIJGrSRMLQfV$u.oyQzAiWpRhkcwJRWYoX3HgEzxHXrY/VuAOaCikHPCzht7.euRtSTzJ/4EdWFBXxpBNfMrT2mhI3J1tuEYpI0";
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFnJ1RYcyw/WBT7CSfvG5fRL591X90Gy1S87BGZPTUmt root@ssd" ];
      extraGroups = [ "docker" ];
    };
    jer = {
      isNormalUser = true;
      home = "/home/jer";
      description = "Jeri V. Luckenbaugh";
      extraGroups = [ "wheel" "docker" ];
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPN0rcHxQVA3/ItRzxhd5eUmIzlUPihAPEP4zkQ/n7Oi jluckenbaugh@ucsd.edu" ];
      initialHashedPassword = "$6$b9oWhqTmy5w/DNyQ$NjzLIEB9n/i0aGzo5nKlP0kgxUORUgkY4bxdfsfAevFtBsMNhKJI3HIMmitq9tQfdrGTVdRa7PrP7CCSoUjh6/";
    };
  };



  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  services.openssh = {
    enable = true;
    settings = { PasswordAuthentication = false; };
  };

  boot.zfs.forceImportRoot = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.git.enable = true;

  security = {
    doas.enable = true;
    sudo.enable = false;
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      mg # emacs-like editor
      jq # other programs
    ;
  };

  # docker setup
  virtualisation.docker.enable = true;
}
