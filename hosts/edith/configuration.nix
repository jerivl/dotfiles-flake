{ pkgs, ... }: {
  # configuration in this file only applies to edith host.
  programs.tmux = {
    enable = true;
    newSession = true;
    terminal = "tmux-direct";
  };
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
	kitty
      ;
    };
  };
  systemd.timers."update-edith" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Unit = "update-edith.service";
    };
  };
  
  systemd.services."update-edith" = {
    script = ''
      GIT_SSH_COMMAND=/run/current-system/sw/bin/ssh
      cd /home/jer/edith
      /run/current-system/sw/bin/git config --global --add safe.directory /home/jer/edith
      /run/current-system/sw/bin/ssh-agent /bin/sh -c '/run/current-system/sw/bin/ssh-add /home/jer/.ssh/id_ed25519; /run/current-system/sw/bin/git pull'
      /run/current-system/sw/bin/docker compose down
      /run/current-system/sw/bin/docker compose up
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
