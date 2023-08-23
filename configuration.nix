#the configuration in this file is shared by all hosts

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
  networking.nameservers = [ "1.1.1.1" "192.168.196.130" "10.0.0.1" ];
  networking.networkmanager.enable = false;
  system.nssDatabases.hosts = [];
  
  users.users = {
    root = {
      initialHashedPassword = "$6$jhFedIJGrSRMLQfV$u.oyQzAiWpRhkcwJRWYoX3HgEzxHXrY/VuAOaCikHPCzht7.euRtSTzJ/4EdWFBXxpBNfMrT2mhI3J1tuEYpI0";
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWKM8yGHV5cBlQ5SSyFjCZBgzc/ebtKfmyHQ7mWvxXZ jluckenbaugh@ucsd.edu" "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmYjfbjlSZkpImpnfN0eftss2bptDoZ6TCmMLghAbhS+8HIJeYEXH0nYSZ2PO0WR+t7gQajNqR2i0FnGy1sEgIog6cB/ddJFybWU2oPmYT7iK3G46q0/BHhZL7Z9LVIIVjInbmZh64okLmvooccf+lbHUdgdobdNTRyh4e+rzxKxwnonQXYwjc5uNlpp7YD/4dkI8/7q0gW7X6in2HqeqUxfY6BvOygAT8qNOKNvhBN58RZYW1YRMlUy89xD2h819CqPg5qvTGNrVM51eLWN+CWCCzb3v9mpXOn+MR7n92WbR7D+3sm5d+2iK7MGfb6wpJAV4l/SofbIF9XCC8WcC3KyrWkqwlYq8fC3v3cbT7NTQ+msknCgzmrMpEtkyQMn4Sj/yuUB7zKuGHTb1C0rFPQ9HSc8/E4cKjaXEYNRiTIiz4YARV+2jbCLjC044gLZPApmZX3wwJyYwwu1jVyQR//T2TKGfCPf7iLoDChXLJaP2I8hYB6n+WKMftHPY3ZeM="];
      extraGroups = [ "docker" ];
    };
    jer = {
      isNormalUser = true;
      home = "/home/jer";
      description = "Jeri V. Luckenbaugh";
      extraGroups = [ "wheel" "docker" ];
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWKM8yGHV5cBlQ5SSyFjCZBgzc/ebtKfmyHQ7mWvxXZ jluckenbaugh@ucsd.edu" "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCmYjfbjlSZkpImpnfN0eftss2bptDoZ6TCmMLghAbhS+8HIJeYEXH0nYSZ2PO0WR+t7gQajNqR2i0FnGy1sEgIog6cB/ddJFybWU2oPmYT7iK3G46q0/BHhZL7Z9LVIIVjInbmZh64okLmvooccf+lbHUdgdobdNTRyh4e+rzxKxwnonQXYwjc5uNlpp7YD/4dkI8/7q0gW7X6in2HqeqUxfY6BvOygAT8qNOKNvhBN58RZYW1YRMlUy89xD2h819CqPg5qvTGNrVM51eLWN+CWCCzb3v9mpXOn+MR7n92WbR7D+3sm5d+2iK7MGfb6wpJAV4l/SofbIF9XCC8WcC3KyrWkqwlYq8fC3v3cbT7NTQ+msknCgzmrMpEtkyQMn4Sj/yuUB7zKuGHTb1C0rFPQ9HSc8/E4cKjaXEYNRiTIiz4YARV+2jbCLjC044gLZPApmZX3wwJyYwwu1jVyQR//T2TKGfCPf7iLoDChXLJaP2I8hYB6n+WKMftHPY3ZeM="];
      initialHashedPassword = "$6$b9oWhqTmy5w/DNyQ$NjzLIEB9n/i0aGzo5nKlP0kgxUORUgkY4bxdfsfAevFtBsMNhKJI3HIMmitq9tQfdrGTVdRa7PrP7CCSoUjh6/";
      packages = builtins.attrValues {
        inherit (pkgs)
          exa
          sd
          du-dust
          fd
          certbot
          lazygit
          lazydocker
          ctop
        ;
      };
    };
  };


  programs.tmux = {
    enable = true;
    newSession = true;
    terminal = "tmux-direct";
  };

  # Root email alias
  environment.etc = {
    "aliases" = {
      text = ''
        root: admin@jerivl.com
      '';
      mode = "0644";
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
  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
  # ZFS snapshoting
  services.sanoid.enable = true;
  services.sanoid.interval = "daily";


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
