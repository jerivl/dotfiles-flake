{ pkgs, ... }: {
  # configuration in this file only applies to edith host.
  programs.tmux = {
    enable = true;
    newSession = true;
    terminal = "tmux-direct";
  };
  services.emacs.enable = false;
  users.users.jer = {
    isNormalUser = true;
    home = "/home/jer";
    description = "Jeri V. Luckenbaugh";
    extraGroups = [ "wheel" "docker" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPN0rcHxQVA3/ItRzxhd5eUmIzlUPihAPEP4zkQ/n7Oi jluckenbaugh@ucsd.edu" ];
    initialHashedPassword = "$6$b9oWhqTmy5w/DNyQ$NjzLIEB9n/i0aGzo5nKlP0kgxUORUgkY4bxdfsfAevFtBsMNhKJI3HIMmitq9tQfdrGTVdRa7PrP7CCSoUjh6/";
    packages = builtins.attrValues {
      inherit (pkgs)
        exa
	sd
	du-dust
	fd
	certbot
      ;
    };
  };
}
