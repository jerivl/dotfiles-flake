# configuration in this file is shared by all hosts

{ pkgs, ... }: {
  # Enable NetworkManager for wireless networking,
  # You can configure networking with "nmtui" command.
  networking.useDHCP = true;
  networking.networkmanager.enable = false;

  
  users.users = {
    root = {
      initialHashedPassword = "$6$jhFedIJGrSRMLQfV$u.oyQzAiWpRhkcwJRWYoX3HgEzxHXrY/VuAOaCikHPCzht7.euRtSTzJ/4EdWFBXxpBNfMrT2mhI3J1tuEYpI0";
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPN0rcHxQVA3/ItRzxhd5eUmIzlUPihAPEP4zkQ/n7Oi jluckenbaugh@ucsd.edu" ];
      extraGroups = [ "docker" ];
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
    sudo.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      jq # other programs
      zerotierone
      ripgrep
      busybox
      dig
      docker-compose
      direnv
      cachix
    ;
    (import (fetchTarball https://install.devenv.sh/latest)).default
  };

  # docker setup
  virtualisation.docker.enable = true;

  # zerotier setup
  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = [ "db64858fed82535e" ];
}
