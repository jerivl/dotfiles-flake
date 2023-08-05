# configuration in this file is shared by all hosts

{ pkgs, ... }: 
let
  zerotier-systemd-manager = pkgs.buildGoModule {
    src = pkgs.fetchFromGitHub {
        owner = "zerotier";
	repo = "zerotier-systemd-manager";
	rev = "6ee6e8c873e7e476f0aeee251e933f6920bae868";
	sha256 = "sha256-oDDTHMwZbGBiqk1di8DJzON8OLb5pcYDdnKrAVC5g74=";
    };
    vendorSha256 = "sha256-40e/FFzHbWo0+bZoHQWzM7D60VUEr+ipxc5Tl0X9E2A=";
    pname = "zerotier-systemd-manager";
    version = "0.4.0";
  };
in
{
  # Enable NetworkManager for wireless networking,
  # You can configure networking with "nmtui" command.
  networking.useDHCP = true;
  services.resolved.enable = true;
  networking.networkmanager.enable = false;
  networking.nameservers = [ "127.0.0.1" "192.168.196.130" "10.0.0.1" ];

  
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
  programs.mosh.enable = true;

  boot.zfs.forceImportRoot = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.git.enable = true;

  security = {
    doas.enable = true;
    sudo.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = [
      pkgs.jq # other programs
      pkgs.zerotierone
      pkgs.ripgrep
      pkgs.busybox
      pkgs.dig
      pkgs.docker-compose
      pkgs.direnv
      pkgs.cachix
      pkgs.openssl
      pkgs.mosh
      pkgs.go
      pkgs.kitty
      zerotier-systemd-manager
  ];

  # docker setup
  virtualisation.docker.enable = true;

  # zerotier setup
  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = [ "db64858fed82535e" ];
}
