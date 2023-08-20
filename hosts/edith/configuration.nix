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
  systemd.timers."update-edith" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1m";
      OnCalendar = "*-*-* 03:00:00";
      Unit = "update-edith.service";
    };
  };
  
  systemd.services."update-edith" = {
    serviceConfig = {
      Type = "oneshot";
      User = "jer";
      WorkingDirectory= "/home/jer/edith";
    };
    path = [ pkgs.git pkgs.openssh pkgs.docker ];
    script = "git pull; docker stop $(docker ps -a -q); docker compose up -d";
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "edith@jerivl.com";
    certs."jerivl.com" = {
      dnsProvider = "cloudflare";
      credentialsFile = "/var/lib/private/cloudflare.conf";
    };
  };

  programs.msmtp = {
    enable = true;
    setSendmail = true;
    defaults = {
      aliases = "/etc/aliases";
      port = 587;
      tls_trust_file = "/var/lib/acme/jerivl.com/cert.pem";
      tls = "on";
      auth = "login";
      tls_starttls = "false";
    };

    accounts = {
      default = {
        host = "in-v3.mailjet.com";
        passwordeval = "cat /var/lib/private/mailjet.conf";
        user = "1edd038c075938686b231810a8337d03";
        from = "edith@jerivl.com";
      };
    };
  };
  
  # Enable zfs email events 
  services.zfs.zed.settings = {
    ZED_DEBUG_LOG = "/tmp/zed.debug.log";
    ZED_EMAIL_ADDR = [ "root" ];
    ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
    ZED_EMAIL_OPTS = "@ADDRESS@";

    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_NOTIFY_VERBOSE = true;

    ZED_USE_ENCLOSURE_LEDS = true;
    ZED_SCRUB_AFTER_RESILVER = true;
  };
  # this option does not work without recompiling the zfs module (slow); will return error
  services.zfs.zed.enableMail = false;

  # Root email alias
#  system.userActivationScripts = {
#    rootEmailAlias = {
#      text = ''echo "root: edith@jerivl.com" | tee /etc/aliases'';
#    };
#  };

}
